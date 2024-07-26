'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/NOTICES": "9ab5a1209ac58ec24e268b552722aba2",
"assets/AssetManifest.bin.json": "8e013f9ae865378c3c545ca02d2cc951",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/intro/intro_1.json": "0986cf2d9bf0318b42cee31f5b5f3e3a",
"assets/assets/intro/intro_2.json": "f286885a146a91139cbff9cfd46fe51c",
"assets/assets/intro/intro_3.json": "5718341c55af23733f547430892a6295",
"assets/assets/signup_congratu.json": "b0cb545f77a5635a99a94a52e48e9afb",
"assets/assets/login_form.json": "c85bde50a8f26ba74bb773899b4bc068",
"assets/assets/sad_mood.json": "da1fffd8d33960db5c19962dcf322e72",
"assets/assets/annoying_mood.json": "e615d07287e8acf2c1e8cfc08cc92ea9",
"assets/assets/AI_generating.json": "ae5d408c790e3f98f17878b480d3b35a",
"assets/assets/logout.json": "e4eaae3813d82c1270b58a343a43c601",
"assets/assets/smile_mood.json": "9aa1e4648750ee0c818187ea219e0e9b",
"assets/assets/angry_mood.json": "a00bc37eac05d517301720868bfbbba7",
"assets/assets/logo.json": "b7213a1f62fd40efe6f1ae1c4bba188a",
"assets/fonts/MaterialIcons-Regular.otf": "f3cf9d42c4452e38437e6ba087a6580c",
"assets/AssetManifest.json": "76974b0d336a94d5e42e7997edbafd4e",
"assets/AssetManifest.bin": "a177987aa755f72a537fc04c32624029",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"index.html": "9859cbe614a1e6c5d49deb35f2a2d52b",
"/": "9859cbe614a1e6c5d49deb35f2a2d52b",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"canvaskit/canvaskit.wasm": "a7401f1c3c2f6f3718f70fff9c560a42",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "3ec4bbdc434e7b9a383c0e75f7d78e0a",
"canvaskit/skwasm.wasm": "0e79dd7cccb9e1496313eeffffc3a6b9",
"canvaskit/skwasm.js.symbols": "7d1398dbd4d1108173353c711b3ccc0b",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/chromium/canvaskit.wasm": "f68f58a2d4f0a4c138b1f3dad9b886c3",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "1f641ad3fedc36384060186a9a42a3e5",
"flutter_bootstrap.js": "76d0aab6fd2ef3f6ca66bef22dfa4668",
"main.dart.js": "5356f16f727ea3f076d4855a063abb46",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "579da6a8042a54a5a333651bc76d9548",
"version.json": "d475322440584b8ee2e4f7f534d58159",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
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
