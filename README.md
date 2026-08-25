# christcentraleastbay.com

An [Astro 7](https://astro.build/) static site deployed on
[Cloudflare Workers](https://developers.cloudflare.com/workers/) using
[Static Assets](https://developers.cloudflare.com/workers/static-assets/).

## Requirements

- Node.js 22.12.0+

## Editing the site

Styling uses [Tailwind CSS v4](https://tailwindcss.com/) (via `@tailwindcss/vite`);
theme tokens live in `src/styles/global.css`. Site-wide content — service times,
address, contact info, staff, and ministries — lives in `src/data/site.ts`; page
prose lives in `src/pages/*.astro`. Shared layout is in `src/layouts/BaseLayout.astro`
and `src/components/`.

Images and optimized video assets live in `public/images/` and `public/media/`;
Astro copies them into `dist/` during the build. Path-level redirects belong in
`public/_redirects`.

## Development

```bash
npm ci
npm run dev
```

## Build

```bash
npm run build
npm run preview
```

## Cloudflare Workers deployment

Deployment is driven by [`wrangler.jsonc`](./wrangler.jsonc), which serves the
built `dist/` directory directly as an asset-only Worker. There is no application
Worker script.

Cloudflare Workers Builds is connected to the GitHub repository and uses:

- **Build command**: `npm run build`
- **Production deploy command**: `npx wrangler deploy`
- **Non-production preview command**: `npx wrangler versions upload`

Pushes to `main` build and deploy automatically; pull requests get preview URLs.
Pages are pre-rendered at build time and served as static assets from Cloudflare's edge.

The apex-to-`www` and HTTP-to-HTTPS redirects are configured as Cloudflare zone
rules. Site path redirects, such as `/give`, are version-controlled in
[`public/_redirects`](./public/_redirects).
