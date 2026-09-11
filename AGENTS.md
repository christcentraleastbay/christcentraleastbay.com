# Repository Guidelines

## Leadership lists

- Keep the Directors, Elder/Elders, Deacons, and Ordained Deacons `people` arrays in `src/data/site.ts` alphabetized by displayed name (first name, then last name for ties), using English alphabetical order.
- Preserve this order when adding or changing names, and check each affected group before submitting. Keep the existing role order and pastor order unless explicitly asked to change them.

## Image assets

- Commit web-ready assets only. Keep camera originals, RAW files, and full-resolution source photos outside the repository, including its Git history.
- Inspect photos before processing. Bake the intended crop into the image file before resizing and encoding; do not use CSS cropping as a substitute for preparing the asset. Preserve the people at the edges and in the front row of group photos.
- Use deterministic image tools (such as Sharp) for cropping, resizing, and format conversion of real photographs. Preserve people's appearance; do not regenerate or retouch faces.
- Prefer WebP for photographs. Preserve SVG for vector artwork and use PNG when lossless detail or compatibility requires it.
- Size images for their largest intended display, allowing for high-density screens. Avoid upscaling. Aim for no more than 2800 pixels wide and less than 1 MiB per committed photo; use smaller sizes when practical. Document the reason if an asset needs to exceed these targets.
- Start with WebP quality 80–90, then inspect the result, especially faces and small details. Strip unnecessary metadata from published images.
- Use descriptive, lowercase, hyphenated filenames. Put optimized sources in `src/assets/` when using Astro's image pipeline; use `public/images/` for assets served directly at stable URLs. Do not commit generated `dist/` images.
- Use Astro's `Image` or `Picture` components for responsive sizes where appropriate. Provide accurate `sizes`, intrinsic dimensions, and meaningful alt text (or empty alt text for purely decorative images). Lazy-load below-the-fold images.
- Display prepared photos at their natural aspect ratio. Larger-photo links should also use optimized assets and preserve the intended crop.
- Before submitting image changes, inspect the final asset, run `npm run build` with the Node version in `.nvmrc`, and check generated image dimensions and file sizes. Confirm that only intended web assets are included in the diff.
