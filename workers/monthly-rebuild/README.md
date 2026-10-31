# Monthly rebuild Worker

The I'm New page lists the next 12 Sundays, computed when the site is built.
If nobody pushes to `main` for a while, those dates run out. This tiny Worker
runs on a Cron Trigger at 09:00 UTC on the 1st of each month and calls the
site's Workers Builds deploy hook, which rebuilds and deploys `main`.

It is its own Worker, separate from the site. The site's build still uses the
root `wrangler.jsonc` and is unaffected by this folder.

## One-time setup

1. **Create the deploy hook.** In the Cloudflare dashboard, go to
   Workers & Pages > `christcentraleastbay` > Settings > Builds > Deploy Hooks.
   Name it `monthly-rebuild`, choose the `main` branch, select Create, and copy
   the URL.
2. **Deploy this Worker** from this folder:

   ```bash
   cd workers/monthly-rebuild
   npx wrangler deploy
   ```

3. **Store the hook URL as a secret** (paste it when prompted):

   ```bash
   npx wrangler secret put DEPLOY_HOOK_URL
   ```

Never put the hook URL in code or config. Anyone who has it can trigger
builds. If it leaks, delete the hook in the dashboard, create a new one, and
run `wrangler secret put` again.

## Checking it works

- In the dashboard's Deploy Hooks list, the hook shows when it was last
  triggered, and the site's build history marks those builds as started by
  a deploy hook.
- To test without waiting for the 1st, run `npx wrangler dev --test-scheduled`
  here and open `http://localhost:8787/__scheduled`. Be aware that with the
  real secret available locally (for example in `.dev.vars`), this triggers a
  real production build.

## Changing the schedule

Edit `triggers.crons` in `wrangler.jsonc` (cron times are UTC), then run
`npx wrangler deploy` again from this folder. Merging to `main` does not
redeploy this Worker.
