# christcentraleastbay.com

Bootstrapped with [Astro](https://astro.build/) and deployed on [Cloudflare Workers](https://developers.cloudflare.com/workers/) using [Static Assets](https://developers.cloudflare.com/workers/static-assets/).

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

## Cloudflare Workers deployment

Deployment is driven by [`wrangler.jsonc`](./wrangler.jsonc), which serves the
built `dist/` directory as static assets. The Workers build runs:

- **Build command**: `npm run build`
- **Deploy command**: `npx wrangler versions upload`

Pushes to `main` build and deploy automatically; pull requests get preview URLs.
Pages are pre-rendered at build time and served as static assets from Cloudflare's edge.
