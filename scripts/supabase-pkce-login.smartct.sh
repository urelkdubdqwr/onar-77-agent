#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# ONAR-HERMES-AGENT
# Supabase Google OAuth PKCE Login
# ============================================================

REDIRECT_HOST="127.0.0.1"
REDIRECT_PORT="3000"
REDIRECT_URI="http://${REDIRECT_HOST}:${REDIRECT_PORT}"

SESSION_FILE="${HOME}/.config/hermes/supabase-session.json"

echo "=== HERMES Supabase PKCE Login ==="
echo

# ------------------------------------------------------------
# Load configuration
# ------------------------------------------------------------

if [[ -f ".env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source .env
    set +a
fi

if [[ -z "${SUPABASE_REF:-}" ]]; then
    read -rp "Supabase project ref: " SUPABASE_REF
fi

if [[ -z "${SUPABASE_ANON_KEY:-}" ]]; then
    read -rsp "Supabase publishable/anon key: " SUPABASE_ANON_KEY
    echo
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
# Generate PKCE
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


# ------------------------------------------------------------
# Start localhost callback catcher
# ------------------------------------------------------------

TMP_DIR="$(mktemp -d)"
CODE_FILE="${TMP_DIR}/code"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo
echo "Starting OAuth callback listener..."
echo "Callback: ${REDIRECT_URI}"
echo

python3 - "$REDIRECT_HOST" "$REDIRECT_PORT" "$CODE_FILE" <<'PY' &
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

host = sys.argv[1]
port = int(sys.argv[2])
code_file = sys.argv[3]

class Handler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def do_GET(self):
        parsed = urlparse(self.path)
        params = parse_qs(parsed.query)

        code = params.get("code", [""])[0]
        error = params.get("error", [""])[0]

        if error:
            with open(code_file, "w") as f:
                f.write("ERROR:" + error)
        elif code:
            with open(code_file, "w") as f:
                f.write(code)

        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()

        if code:
            self.wfile.write(
                b"<html><body><h2>Login berhasil.</h2>"
                b"<p>Kembali ke terminal Hermes.</p></body></html>"
            )
        else:
            self.wfile.write(
                b"<html><body><h2>OAuth gagal.</h2>"
                b"<p>Kembali ke terminal Hermes.</p></body></html>"
            )

server = HTTPServer((host, port), Handler)
server.handle_request()
PY

CALLBACK_PID=$!

# ------------------------------------------------------------
# Build authorization URL
# ------------------------------------------------------------

AUTH_URL="${SUPABASE_URL}/auth/v1/authorize?provider=google&redirect_to=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$REDIRECT_URI")&code_challenge=${CODE_CHALLENGE}&code_challenge_method=S256&flow_type=pkce"

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

if [[ "$CODE" == ERROR:* ]]; then
    echo "OAuth error: ${CODE#ERROR:}"
    exit 1
fi

echo "OAuth code diterima."
echo "Menukar code ke Supabase session..."

# ------------------------------------------------------------
# Exchange PKCE code for session
# ------------------------------------------------------------

RESPONSE="$(
    curl -fsS \
        "${SUPABASE_URL}/auth/v1/token?grant_type=pkce" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Content-Type: application/json" \
        -d "{
            \"auth_code\": \"${CODE}\",
            \"code_verifier\": \"${CODE_VERIFIER}\",
            \"redirect_to\": \"${REDIRECT_URI}\"
        }"
)"

# ------------------------------------------------------------
# Validate response
# ------------------------------------------------------------

if ! printf '%s' "$RESPONSE" | python3 -c '
import json, sys
data=json.load(sys.stdin)
if not data.get("access_token"):
    raise SystemExit(1)
'; then
    echo
    echo "ERROR: Supabase tidak mengembalikan access token."
    echo
    printf '%s\n' "$RESPONSE"
    exit 1
fi

# ------------------------------------------------------------
# Save session securely
# ------------------------------------------------------------

mkdir -p "$(dirname "$SESSION_FILE")"

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
