// Rebuilds the christcentraleastbay site on a schedule by calling its
// Workers Builds deploy hook. The I'm New page lists upcoming Sundays
// computed at build time, so the site needs a fresh build now and then
// even when nobody pushes a change.
//
// DEPLOY_HOOK_URL is a secret (wrangler secret put DEPLOY_HOOK_URL).
// Never commit the URL: anyone who has it can trigger builds.

export default {
  async scheduled(controller, env) {
    if (!env.DEPLOY_HOOK_URL) {
      throw new Error("DEPLOY_HOOK_URL secret is not set");
    }

    const res = await fetch(env.DEPLOY_HOOK_URL, { method: "POST" });
    const body = await res.text();

    if (!res.ok) {
      throw new Error(`Deploy hook returned ${res.status}: ${body}`);
    }

    console.log(`Rebuild triggered (${controller.cron}): ${body}`);
  },
};
