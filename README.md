# christcentraleastbay.com

Bootstrapped with [Astro](https://astro.build/) and configured for deployment on [Cloudflare Pages](https://pages.cloudflare.com/).

## Requirements

- Node.js 22.12.0+

## Development

```bash
npm install
npm run dev
```

## Build

```bash
npm run build
npm run preview
```

## Cloudflare Pages deployment

Use the following settings in Cloudflare Pages:

- **Framework preset**: Astro
- **Build command**: `npm run build`
- **Build output directory**: `dist`

Pages are pre-rendered at build time and served as static assets from Cloudflare's edge.
