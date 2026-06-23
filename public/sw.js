const CACHE_NAME = 'malawi-v3';

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('message', (e) => {
  if (e.data && e.data.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('fetch', (e) => {
  const { request } = e;
  const url = new URL(request.url);

  // HTML: network-first — nunca cacheado
  if (request.headers.get('Accept')?.includes('text/html') ||
      url.pathname.endsWith('.html') || url.pathname === '/') {
    e.respondWith(fetch(request).catch(() => caches.match(request)));
    return;
  }

  // Supabase: network-first
  if (url.hostname.includes('supabase.co')) {
    e.respondWith(
      fetch(request).catch(() =>
        new Response('{"error":"offline"}', { headers: { 'Content-Type': 'application/json' } })
      )
    );
    return;
  }

  // Assets: cache-first com populamento dinâmico
  e.respondWith(
    caches.match(request).then((cached) => {
      if (cached) return cached;
      return fetch(request).then((res) => {
        if (res.ok) {
          const clone = res.clone();
          caches.open(CACHE_NAME).then((c) => c.put(request, clone));
        }
        return res;
      });
    })
  );
});
