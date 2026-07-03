/**
 * Maintenance-mode gate in front of the static site.
 *
 * Because `assets.run_worker_first` is true, this Worker runs on every request
 * before any static asset is served. When maintenance mode is on, the public
 * gets a 503 maintenance page; you can bypass it with a preview token.
 *
 * Toggle:  set the `MAINTENANCE_MODE` var in wrangler.jsonc ("true"/"false") and
 *          redeploy (push to main). "false" serves the real site to everyone.
 * Preview: set a `MAINTENANCE_BYPASS_TOKEN` secret on the Worker, then visit
 *          https://www.christcentraleastbay.com/?preview=YOUR_TOKEN once. That
 *          sets a cookie so you can browse the real site normally for 24h.
 *          If no token is configured, the gate is absolute (no bypass).
 */

const BYPASS_COOKIE = "ccb_preview";

export default {
  async fetch(request, env) {
    const maintenanceOn = String(env.MAINTENANCE_MODE) === "true";

    if (maintenanceOn && !hasBypassCookie(request, env)) {
      const url = new URL(request.url);
      const token = env.MAINTENANCE_BYPASS_TOKEN;

      // A valid ?preview=<token> sets the bypass cookie, then redirects to a
      // clean URL so the token isn't left in the address bar or logs.
      if (token && url.searchParams.get("preview") === token) {
        url.searchParams.delete("preview");
        return new Response(null, {
          status: 302,
          headers: {
            Location: url.toString(),
            "Set-Cookie": `${BYPASS_COOKIE}=${token}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=86400`,
          },
        });
      }

      return new Response(MAINTENANCE_HTML, {
        status: 503,
        headers: {
          "Content-Type": "text/html; charset=utf-8",
          "Retry-After": "3600",
          "Cache-Control": "no-store",
        },
      });
    }

    // Maintenance off, or a valid bypass cookie present: serve the real site.
    return env.ASSETS.fetch(request);
  },
};

function hasBypassCookie(request, env) {
  const token = env.MAINTENANCE_BYPASS_TOKEN;
  if (!token) return false;
  const cookie = request.headers.get("Cookie") || "";
  return cookie
    .split(";")
    .some((part) => part.trim() === `${BYPASS_COOKIE}=${token}`);
}

const MAINTENANCE_HTML = `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <meta name="robots" content="noindex" />
    <title>Christ Central East Bay — Coming Soon</title>
    <style>
      :root {
        font-family: ui-sans-serif, system-ui, sans-serif;
        color-scheme: light dark;
      }
      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-content: center;
        padding: 2rem;
        background: #fafaf9;
        color: #1f2937;
      }
      @media (prefers-color-scheme: dark) {
        body {
          background: #111827;
          color: #e5e7eb;
        }
      }
      main {
        max-width: 42rem;
        text-align: center;
      }
      h1 {
        font-size: clamp(2rem, 5vw, 3rem);
        margin: 0 0 1rem;
      }
      p {
        margin: 0;
        font-size: 1.125rem;
        line-height: 1.6;
      }
    </style>
  </head>
  <body>
    <main>
      <h1>Christ Central East Bay</h1>
      <p>Our new website is on the way. Please check back soon.</p>
    </main>
  </body>
</html>
`;
