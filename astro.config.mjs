// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://www.christcentraleastbay.com',
  // Cloudflare already serves pages at their trailing-slash URL and 307s the
  // bare path; emitting trailing slashes keeps internal links redirect-free
  // and matches the canonical URLs.
  trailingSlash: 'always',
  compressHTML: true,
  integrations: [
    sitemap({
      filter: (page) => !page.endsWith('/404/'),
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
  },
});
