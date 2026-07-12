# christcentraleastbay.com

Bootstrapped with [Astro](https://astro.build/) and deployed on [Cloudflare Workers](https://developers.cloudflare.com/workers/) using [Static Assets](https://developers.cloudflare.com/workers/static-assets/).

## Requirements

- Node.js 22.12.0+

## Editing the site

Styling uses [Tailwind CSS v4](https://tailwindcss.com/) (via `@tailwindcss/vite`);
theme tokens live in `src/styles/global.css`. Site-wide content — service times,
address, contact info, staff, and ministries — lives in `src/data/site.ts`; page
prose lives in `src/pages/*.astro`. Shared layout is in `src/layouts/BaseLayout.astro`
and `src/components/`.

While `MAINTENANCE_MODE` is `"true"` (see `wrangler.jsonc`), the deployed site shows
a "coming soon" page; preview the real site with the bypass token (see
`worker/index.js`).

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
