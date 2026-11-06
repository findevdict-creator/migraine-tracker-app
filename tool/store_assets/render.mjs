// Renders the launcher icons and store graphics from the brand SVGs and
// the central config, with headless Chromium (Playwright).
//
//   cd tool/store_assets && npm install && npx playwright install chromium && npm run render
//
// Inputs (change these, then re-run):
//   assets/brand/logo_mark.svg         the icon artwork
//   lib/config/app_config.dart         AppIdentity.name, AppThemeTokens.seed
// Outputs:
//   assets/brand/launcher_icon.png             1024 square, full bleed (iOS, legacy Android)
//   assets/brand/launcher_icon_foreground.png  1024, artwork in the adaptive safe zone
//   docs/store/assets/play_icon_512.png        Play hi-res icon
//   docs/store/assets/play_feature_graphic.png Play feature graphic, 1024 × 500
//   docs/store/assets/app_store_icon_1024.png  App Store icon, no transparency
// Then `dart run flutter_launcher_icons` writes the platform icon sets.
import { readFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { chromium } from "playwright";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const config = readFileSync(join(root, "lib/config/app_config.dart"), "utf8");

function configValue(pattern, what) {
  const match = config.match(pattern);
  if (!match) throw new Error(`app_config.dart: ${what} not found`);
  return match[1];
}

const name = configValue(/static const String name = '([^']+)'/, "AppIdentity.name");
const seed = "#" + configValue(/static const Color seed = Color\(0xFF([0-9A-Fa-f]{6})\)/, "AppThemeTokens.seed");
const mark = readFileSync(join(root, "assets/brand/logo_mark.svg"), "utf8");
// The artwork without its rounded background square, for layouts that
// supply their own background.
const markBare = mark.replace(/<rect[^>]*\/>\s*/, "");

const escapeHtml = (s) => s.replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);

const page = (width, height, body, background = "transparent") => `<!doctype html>
<html><head><style>
  html, body { margin: 0; width: ${width}px; height: ${height}px; background: ${background}; overflow: hidden; }
  body { display: flex; align-items: center; justify-content: center; font-family: system-ui, sans-serif; }
  svg { display: block; }
</style></head><body>${body}</body></html>`;

const sized = (svg, size) => svg.replace("<svg ", `<svg width="${size}" height="${size}" `);

const outputs = [
  // Full bleed: the background colour fills the corners the OS rounds.
  ["assets/brand/launcher_icon.png", 1024, 1024, page(1024, 1024, sized(markBare, 1024), seed), false],
  // Adaptive foreground: artwork within the central 66% safe zone.
  ["assets/brand/launcher_icon_foreground.png", 1024, 1024, page(1024, 1024, sized(markBare, 676)), true],
  ["docs/store/assets/play_icon_512.png", 512, 512, page(512, 512, sized(markBare, 512), seed), false],
  ["docs/store/assets/app_store_icon_1024.png", 1024, 1024, page(1024, 1024, sized(markBare, 1024), seed), false],
  [
    "docs/store/assets/play_feature_graphic.png",
    1024,
    500,
    page(
      1024,
      500,
      `<div style="display:flex;align-items:center;gap:40px;color:#fff">
         ${sized(mark, 220)}
         <div style="font-size:64px;font-weight:700;letter-spacing:-1px">${escapeHtml(name)}</div>
       </div>`,
      seed,
    ),
    false,
  ],
];

const browser = await chromium.launch();
try {
  for (const [path, width, height, html, transparent] of outputs) {
    const tab = await browser.newPage({ viewport: { width, height }, deviceScaleFactor: 1 });
    await tab.setContent(html);
    mkdirSync(dirname(join(root, path)), { recursive: true });
    await tab.screenshot({ path: join(root, path), omitBackground: transparent });
    await tab.close();
    console.log(`wrote ${path} (${width} × ${height})`);
  }
} finally {
  await browser.close();
}
