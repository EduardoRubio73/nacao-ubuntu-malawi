const CACHE_NAME = 'malawi-v2';
const STATIC_ASSETS = ['/public/images/semfronteiraslogo.png', '/public/images/logo-ubuntu-africa.png'];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
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

self.addEventListener('fetch', (e) => {
  const { request } = e;
  const url = new URL(request.url);

  // HTML sempre da rede — nunca cacheado para garantir versão atualizada
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

  // Assets estáticos (imagens, fontes, JS externo): cache-first
  e.respondWith(
    caches.match(request).then((cached) => cached || fetch(request))
  );
});
