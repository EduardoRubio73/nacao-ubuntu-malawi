const CACHE_NAME = 'malawi-v4';

self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (e) => {
  e.waitUntil(
    Promise.all([
      caches.keys().then(keys => Promise.all(keys.map(k => caches.delete(k)))),
      self.clients.matchAll({ type: 'window', includeUncontrolled: true })
        .then(clients => clients.forEach(c => c.navigate(c.url)))
    ])
  );
  self.clients.claim();
});

self.addEventListener('message', e => {
  if (e.data?.type === 'SKIP_WAITING') self.skipWaiting();
});
