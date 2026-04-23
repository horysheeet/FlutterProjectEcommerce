'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d953b33e0c3cb72ee1f08aa4ce88b714",
"assets/AssetManifest.bin.json": "8f394c205921bf3d35b2aaa50bb3d5db",
"assets/assets/images/BYOU/BLK.JPG": "f5bd0b013cac4ce29ebf47a8a8deac47",
"assets/assets/images/BYOU/BLK_BACK.jpg": "7cd1a0f56b33900781f012798cac082b",
"assets/assets/images/BYOU/GRN.jpg": "70d4b467a4da2a1a420f00dcab8b5da3",
"assets/assets/images/BYOU/WHT.jpg": "b74e09374a8eb8084c507774a1924ec8",
"assets/assets/images/Logo/logo.png": "12f4290fb5afe1010911abf5b6a5c370",
"assets/assets/images/Nano%2520Expansion/2.jpg": "3f63da1404b2accd06f9fa61cce3449a",
"assets/assets/images/Nano%2520Expansion/4.jpg": "0284544c69dba3c02e550ccb87926478",
"assets/assets/images/Others/1.png": "782b7245f32b6b0cecc91eeb47324662",
"assets/assets/images/Others/2.png": "767db90684053da1ef752bf4513744da",
"assets/assets/images/Rover/1.jpg": "7e7df311ab48db9e1ff635d2bdbcdbe6",
"assets/assets/images/Rover/2.jpg": "99a782b5b600a90ddf3921a590dca266",
"assets/assets/images/Rover/3.jpg": "bffb3c516fbe622e2bca50f135bfe1b3",
"assets/assets/product_images/product_1/B1.png": "61c7974198a3269d73c8914c65971183",
"assets/assets/product_images/product_1/B2.png": "9ef46cae5cf93936ae000c93284ef372",
"assets/assets/product_images/product_1/G1.png": "5b041d93d6a40f2d08ba0c449ec42ccc",
"assets/assets/product_images/product_1/G2.png": "73b66eb0cb3f31860d4f6656efee54ae",
"assets/assets/product_images/product_1/W1.png": "a6658760422eb39cf5827a256fae80fb",
"assets/assets/product_images/product_1/W2.png": "dfbb5076ef2d437fafa57e081f259c62",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "d0899cc42ed59ff9754307c3c6f97383",
"assets/NOTICES": "e40cf0771fc6406e2e3929b5033e498b",
"assets/Product%2520Images/Product%25201/B1.png": "9273e7a8b9d9e00f0860f0aee717b82f",
"assets/Product%2520Images/Product%25201/B2.png": "0fbaaeab72f7e501f5a38cdf27124d93",
"assets/Product%2520Images/Product%25201/G1.png": "d57b44594964a53b257bdc189735b7b5",
"assets/Product%2520Images/Product%25201/G2.png": "73b66eb0cb3f31860d4f6656efee54ae",
"assets/Product%2520Images/Product%25201/W1.png": "a6658760422eb39cf5827a256fae80fb",
"assets/Product%2520Images/Product%25201/W2.png": "dfbb5076ef2d437fafa57e081f259c62",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "de749eace3ac4d9308dab6be29063f70",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "526296e51ac305ea9b1bfe15b3ac4301",
"/": "526296e51ac305ea9b1bfe15b3ac4301",
"main.dart.js": "f114ad8a53adefcb9af66907bbce92f4",
"manifest.json": "b25b80f70bcd0fd61ad2a47c21b44372",
"version.json": "f067cb4d2e3f86b35da09fa8b5d4e242"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
