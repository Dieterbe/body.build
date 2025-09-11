export async function onRequest({ request, env, next }) {
  const url = new URL(request.url);

  // Let real files (with an extension) pass through to static assets
  if (/\.[a-zA-Z0-9]+$/.test(url.pathname)) {
    return next();
  }

  // For any navigation under /app/*, serve the SPA shell
  // (env.ASSETS.fetch expects the "pretty" path; /app/ -> /app/index.html)
  return env.ASSETS.fetch(new Request(new URL("/app/", url), request));
}
