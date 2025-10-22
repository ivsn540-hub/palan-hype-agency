self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open('v1').then(function (cache) {
      return cache.addAll([
        '/index.html',
        '/vedushie.html',
        '/images/interface.jpg',
        '/music/pelet-pelet.mp3',
        '/music/yuratap-tese.mp3'
        // добавь всё, что нужно закешировать
      ]);
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request).then(function (response) {
      return response || fetch(event.request);
    })
  );
});
