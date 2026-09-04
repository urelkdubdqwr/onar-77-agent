#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# ONAR-HERMES-AGENT
# Supabase Google OAuth PKCE Login (hardened)
# ============================================================
# Security rules (NEVER violate):
#   - Never print access_token / refresh_token / session contents
#   - Never send session files to chat, logs, or diagnostics
#   - Never commit session files (see .gitignore)
#   - Never use SUPABASE_SERVICE_ROLE_KEY in this flow (anon/publishable only)
# ============================================================

REDIRECT_HOST="127.0.0.1"
REDIRECT_PORT="3000"
REDIRECT_URI="http://${REDIRECT_HOST}:${REDIRECT_PORT}"

SESSION_FILE="${HOME}/.config/hermes/supabase-session.web3track.json"

echo "=== HERMES Supabase PKCE Login ==="
echo

# ------------------------------------------------------------
# Load ONLY the required variables from .env (no wholesale source)
# ------------------------------------------------------------

if [[ -f ".env" ]]; then
    if [[ -z "${SUPABASE_REF:-}" ]]; then
        SUPABASE_REF="$(grep -m1 '^SUPABASE_REF=' .env | cut -d= -f2- || true)"
    fi
    if [[ -z "${SUPABASE_ANON_KEY:-}" ]]; then
        SUPABASE_ANON_KEY="$(grep -m1 -E '^(SUPABASE_ANON_KEY|SUPABASE_PUBLISHABLE_KEY)=' .env | cut -d= -f2- || true)"
    fi
fi

if [[ -z "${SUPABASE_REF:-}" ]]; then
    read -rp "Supabase project ref: " SUPABASE_REF
fi

if [[ -z "${SUPABASE_ANON_KEY:-}" ]]; then
    read -rsp "Supabase publishable/anon key: " SUPABASE_ANON_KEY
    echo
fi

# ------------------------------------------------------------
# Validate SUPABASE_REF (reject malformed input)
# ------------------------------------------------------------

if [[ ! "${SUPABASE_REF}" =~ ^[A-Za-z0-9-]{8,40}$ ]]; then
    echo "ERROR: SUPABASE_REF has an unexpected format (expected 8-40 chars, alphanumeric/hyphen)."
    exit 1
fi

# ------------------------------------------------------------
# Reject service-role keys (must never enter this flow)
# ------------------------------------------------------------

if [[ "${SUPABASE_ANON_KEY}" == sb_secret_* ]]; then
    echo "ERROR: sb_secret_* is a service/secret key. This flow requires the anon/publishable key."
    exit 1
fi

if [[ "${SUPABASE_ANON_KEY}" == eyJ* ]]; then
    # Legacy JWT anon key — decode payload and verify role is not service_role
    JWT_ROLE="$(printf '%s' "${SUPABASE_ANON_KEY}" | cut -d. -f2 | base64 -d 2>/dev/null | grep -o '"role"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '[a-z_]*"$' | tr -d '"' || true)"
    if [[ "${JWT_ROLE}" == "service_role" ]]; then
        echo "ERROR: JWT supplied is a service_role key. This flow requires the anon key."
        exit 1
    fi
fi

SUPABASE_URL="https://${SUPABASE_REF}.supabase.co"

# ------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------

for cmd in openssl curl python3; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: $cmd tidak ditemukan."
        exit 1
    fi
done

# ------------------------------------------------------------
# Generate PKCE + OAuth state
# ------------------------------------------------------------

CODE_VERIFIER="$(
    openssl rand -base64 48 |
    tr '+/' '-_' |
    tr -d '=\n'
)"

CODE_CHALLENGE="$(
    printf '%s' "$CODE_VERIFIER" |
    openssl dgst -sha256 -binary |
    base64 |
    tr '+/' '-_' |
    tr -d '='
)"

OAUTH_STATE="$(openssl rand -hex 32)"

# ------------------------------------------------------------
# Start localhost callback catcher (strict validation)
# ------------------------------------------------------------

TMP_DIR="$(mktemp -d)"
chmod 700 "$TMP_DIR"
CODE_FILE="${TMP_DIR}/code"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo
echo "Starting OAuth callback listener..."
echo "Callback: ${REDIRECT_URI}"
echo

python3 - "$REDIRECT_HOST" "$REDIRECT_PORT" "$CODE_FILE" "$OAUTH_STATE" <<'PY' &
import os
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

host = sys.argv[1]
port = int(sys.argv[2])
code_file = sys.argv[3]
expected_state = sys.argv[4]

class Handler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def _reply(self, ok):
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        if ok:
            self.wfile.write(
                b"<html><body><h2>Login berhasil.</h2>"
                b"<p>Kembali ke terminal Hermes.</p></body></html>"
            )
        else:
            self.wfile.write(
                b"<html><body><h2>OAuth gagal.</h2>"
                b"<p>Kembali ke terminal Hermes.</p></body></html>"
            )

    def do_GET(self):
        parsed = urlparse(self.path)
        # Only the root callback path is accepted
        if parsed.path not in ("/", ""):
            self._reply(False)
            return
        params = parse_qs(parsed.query)
        code = params.get("code", [""])[0]
        state = params.get("state", [""])[0]
        error = params.get("error", [""])[0]

        ok = bool(code and state == expected_state)
        # Reply FIRST, then capture — so the browser always gets a clean page
        self._reply(ok or bool(error))
        if error:
            with open(code_file, "w") as f:
                f.write("ERROR:" + error)
            os.chmod(code_file, 0o600)
        elif ok:
            with open(code_file, "w") as f:
                f.write(code)
            os.chmod(code_file, 0o600)
        # else: mismatched/missing state or bare code -> rejected, keep listening

server = HTTPServer((host, port), Handler)
# Keep serving until a valid code/error is captured (rejects junk requests)
while not os.path.exists(code_file):
    server.handle_request()
PY

CALLBACK_PID=$!

# ------------------------------------------------------------
# Build authorization URL (with state)
# ------------------------------------------------------------

AUTH_URL="${SUPABASE_URL}/auth/v1/authorize?provider=google&redirect_to=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$REDIRECT_URI")&state=${OAUTH_STATE}&code_challenge=${CODE_CHALLENGE}&code_challenge_method=S256&flow_type=pkce"

echo "Opening Google OAuth..."
echo
echo "$AUTH_URL"
echo

# Try to open browser
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$AUTH_URL" >/dev/null 2>&1 &
elif command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "$AUTH_URL" >/dev/null 2>&1 &
else
    echo "Tidak menemukan browser launcher."
    echo "Buka URL di atas secara manual."
fi

echo "Menunggu callback OAuth..."

# ------------------------------------------------------------
# Wait for callback
# ------------------------------------------------------------

TIMEOUT=180
ELAPSED=0

while [[ ! -s "$CODE_FILE" ]]; do
    if ! kill -0 "$CALLBACK_PID" 2>/dev/null; then
        break
    fi

    if (( ELAPSED >= TIMEOUT )); then
        echo
        echo "ERROR: OAuth timeout."
        kill "$CALLBACK_PID" 2>/dev/null || true
        exit 1
    fi

    sleep 1
    ((ELAPSED+=1))
done

wait "$CALLBACK_PID" 2>/dev/null || true

if [[ ! -s "$CODE_FILE" ]]; then
    echo "ERROR: Tidak menerima OAuth code."
    exit 1
fi

CODE="$(cat "$CODE_FILE")"
rm -f "$CODE_FILE"   # burn the one-time code immediately

if [[ "$CODE" == ERROR:* ]]; then
    echo "OAuth error: ${CODE#ERROR:}"
    exit 1
fi

echo "OAuth code diterima."
echo "Menukar code ke Supabase session..."

# ------------------------------------------------------------
# Exchange PKCE code for session (bounded timeouts)
# ------------------------------------------------------------

RESPONSE="$(
    curl -fsS \
        --connect-timeout 10 \
        --max-time 30 \
        "${SUPABASE_URL}/auth/v1/token?grant_type=pkce" \
        -H "apikey: ${SUPA...EY}" \
        -H "Content-Type: application/json" \
        -d "{
            \"auth_code\": \"${CODE}\",
            \"code_verifier\": \"${CODE_VERIFIER}\",
            \"redirect_to\": \"${REDIRECT_URI}\"
        }"
)"

# ------------------------------------------------------------
# Validate response (sanitized output only — never dump raw)
# ------------------------------------------------------------

if ! printf '%s' "$RESPONSE" | python3 -c '
import json, sys
data=json.load(sys.stdin)
if not data.get("access_token"):
    raise SystemExit(1)
'; then
    echo
    echo "ERROR: Supabase tidak mengembalikan access token."
    # Print only a sanitized summary, never tokens
    printf '%s' "$RESPONSE" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print("(unparseable response)"); raise SystemExit(0)
msg = data.get("message") or data.get("error_description") or data.get("error") or "unknown error"
print("Reason:", str(msg)[:200])
'
    exit 1
fi

# ------------------------------------------------------------
# Save session securely (dir 700, file 600)
# ------------------------------------------------------------

mkdir -p "$(dirname "$SESSION_FILE")"
chmod 700 "$(dirname "$SESSION_FILE")"

umask 077
printf '%s' "$RESPONSE" > "$SESSION_FILE"
chmod 600 "$SESSION_FILE"

echo
echo "========================================"
echo " Supabase login berhasil"
echo "========================================"
echo
echo "Session:"
echo "  ${SESSION_FILE}"
echo
echo "Permissions:"
ls -l "$SESSION_FILE"
echo
echo "RULE: session file berisi token sensitif."
echo "      JANGAN pernah di-commit, di-print, dikirim ke chat, atau masuk log."
echo

# ------------------------------------------------------------
# Show safe information only
# ------------------------------------------------------------

python3 - "$SESSION_FILE" <<'PY'
import json
import sys

with open(sys.argv[1]) as f:
    data = json.load(f)

print("Token type :", data.get("token_type"))
print("Expires in :", data.get("expires_in"), "seconds")
print("User ID    :", data.get("user", {}).get("id"))
print("Email      :", data.get("user", {}).get("email"))
print()
print("Access/refresh token TIDAK ditampilkan.")
PY

echo
echo "HERMES sekarang punya Supabase session."
