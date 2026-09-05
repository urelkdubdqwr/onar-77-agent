import asyncio, os

async def main():
    from playwright.async_api import async_playwright
    async with async_playwright() as pw:
        browser = await pw.chromium.launch(
            executable_path="/home/onar/.cache/ms-playwright/chromium-1234/chrome-linux64/chrome",
            args=["--no-sandbox"])
        page = await browser.new_page(viewport={"width": 1080, "height": 1920})
        await page.goto("file:///home/onar/onar-hermes-agent/story/carousel.html")
        await page.wait_for_timeout(1500)
        slides = page.locator(".slide")
        n = await slides.count()
        out = "/home/onar/onar-hermes-agent/story/out"
        os.makedirs(out, exist_ok=True)
        for i in range(n):
            await slides.nth(i).screenshot(path=f"{out}/slide{i+1:02d}.png")
            print("rendered", i + 1)
        await browser.close()

asyncio.run(main())
