# Publish Root as a live website

This project is prepared for Flutter Web and includes a GitHub Actions workflow that builds and deploys the app automatically.

## Easiest option: GitHub Pages

1. Put these files in the `gusbusx/root` repository and commit/push them to the `main` branch.
2. On GitHub open **Settings → Pages**.
3. Under **Build and deployment**, set **Source** to **GitHub Actions**.
4. Open the **Actions** tab. The workflow named **Build and deploy Root (Flutter Web)** will build the app and publish it.
5. Once the workflow finishes, Root will be available at:

   `https://gusbusx.github.io/root/`

After that, every push to `main` automatically rebuilds and republishes the demo.

## What GitHub is doing for you

You do **not** upload the raw Flutter project directly to a normal web host. Flutter first compiles it into static web files. The included workflow runs:

```bash
flutter pub get
flutter build web --release --base-href "/root/"
```

and publishes the generated `build/web` directory.

## Build locally (optional)

If Flutter is installed on your computer, you can also build manually:

```bash
flutter pub get
flutter build web --release
```

Then upload the **contents of `build/web/`** to any static host such as Cloudflare Pages, Firebase Hosting, Netlify, or a standard web server.

## Web compatibility changes included

- Local-file image handling now uses platform-specific code so `dart:io` does not break the web build.
- The portrait orientation lock remains on native/mobile builds but is skipped in browsers.
- The web bootstrap page and metadata were cleaned up for a standalone public demo.
- A GitHub Pages deployment workflow was added.
