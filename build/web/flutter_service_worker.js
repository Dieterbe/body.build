'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "44ccc512e6e4d26e60a1a660a880fd7d",
"flutter_bootstrap.js": "e801ef5b818083fe8ee120a380c32dbe",
"docs/quick-start/index.html": "13b9bfea75b2e3cfb96d2b422a77971a",
"docs/img/undraw_docusaurus_react.svg": "b64ae8e3c10e5ff2ec85a653cfe6edf8",
"docs/img/docusaurus.png": "7fa1a026116afe175cae818030d4ffc4",
"docs/img/workout-programmer-setup.png": "57da5a0871454e424f10e32a9be049fe",
"docs/img/favicon.ico": "4343e07bf942aefb5f334501958fbc0e",
"docs/img/workout-programmer-program-analysis.png": "ba68d805fed7d65f857d0480337c1518",
"docs/img/workout-programmer-add-set.png": "7723c601052786c1944d5bf9758a5018",
"docs/img/logo.svg": "91a0eea6b8c47b50d72917adf0a3ceec",
"docs/img/undraw_docusaurus_mountain.svg": "a6b83d7b4c3cf36cb21eb7a9721716dd",
"docs/img/dieter-menno.jpg": "752a4c7ca1883f47297b9022803680cb",
"docs/img/undraw_docusaurus_tree.svg": "8fa6e79a15c385d7b2dc4bb761a2e9e3",
"docs/img/docusaurus-social-card.jpg": "000de4a48405bd21b7eec1abc07ede6c",
"docs/img/workout-programmer.png": "71477f9cb14fefcb4fbe296dd0173f5f",
"docs/faq/index.html": "10f18873ef0e6c8ab127a65207f18fe4",
"docs/index.html": "0af6a2cca366c1e4fa16ab426e5bb685",
"docs/404.html": "af43a99772fce71379bbf9fad308f33e",
"docs/backstory/index.html": "7ab2e40aa329e860a1a15dc3ebf35747",
"docs/assets/js/runtime~main.6a47f68b.js": "3d6b8d3195dca180af98a94821e22bd0",
"docs/assets/js/0480b142.be54bf37.js": "2c0f373b4acd91d5972820537708f2f1",
"docs/assets/js/11b43341.358b9214.js": "a9fbb1e44bd40cc126143dc2894dc47a",
"docs/assets/js/42.26b08591.js": "2a1da4c042921f49b35ebc1693167c53",
"docs/assets/js/main.7059bb1f.js": "63d66feda1fc2ad5afa1459b3876e202",
"docs/assets/js/11b43341.f5d2c134.js": "cd973fbd13ec9d368c31c9188da6becf",
"docs/assets/js/17896441.ae20c164.js": "c8582a500c5676d72fd3610669326a7d",
"docs/assets/js/main.df7a04c3.js.LICENSE.txt": "abca7df598e94467c5bdfc69d2f26989",
"docs/assets/js/main.90c6b56f.js.LICENSE.txt": "abca7df598e94467c5bdfc69d2f26989",
"docs/assets/js/c377a04b.20a63214.js": "e1c8954b06786ee158ead343047c3d7f",
"docs/assets/js/a94703ab.b02edaba.js": "672960254b128ba2618820413c91369f",
"docs/assets/js/runtime~main.5f4af573.js": "367815dee4e92b7c1b981944d596922a",
"docs/assets/js/a7bd4aaa.5850ac70.js": "976d48e453b42f9c4d23f2626f15ef46",
"docs/assets/js/5e95c892.d9c8b10a.js": "db692be1da524d711504005a1fcd8008",
"docs/assets/js/11b43341.1bf0bdc5.js": "26bb0c3a8ddfce8791c0832aa824e8f4",
"docs/assets/js/runtime~main.93fcf1b3.js": "519e49e82b0bab975875987b0cb61dce",
"docs/assets/js/main.f5d47ab2.js": "f7f2064d25f4d9694f9b5337dd78f6c7",
"docs/assets/js/9e226ce3.fb215559.js": "6fac8409f5df2f07c66b045a4e635db9",
"docs/assets/js/72e14192.07754fe6.js": "8c160f73607d3fd3e3006e36deeadb65",
"docs/assets/js/main.7059bb1f.js.LICENSE.txt": "abca7df598e94467c5bdfc69d2f26989",
"docs/assets/js/11b43341.7ab5f676.js": "29f5904c2edd132bb3a52f35fd6dfd93",
"docs/assets/js/main.df7a04c3.js": "76fed76e9fb76594cb82693032f1444f",
"docs/assets/js/main.f5d47ab2.js.LICENSE.txt": "abca7df598e94467c5bdfc69d2f26989",
"docs/assets/js/aba21aa0.cf912736.js": "7feef7e8fdbdad0146cf64b76e301e50",
"docs/assets/js/9e226ce3.0d4d62e4.js": "88227f50ed31480f4028be823927d6dd",
"docs/assets/js/runtime~main.088a3a3d.js": "c785ec03037d072f8965e892b3722d94",
"docs/assets/js/runtime~main.a3cc36a5.js": "ac497108a0af24776a0953d5297d7a51",
"docs/assets/js/c377a04b.4ed95e6f.js": "d55e59ea7f10fd4e8d2b6e11eb241717",
"docs/assets/js/c377a04b.5871cf84.js": "09c14cb00d797494bbb6e3a7cdcabf9c",
"docs/assets/js/main.90c6b56f.js": "51462f95ba40ad6d96e150b830ff7446",
"docs/assets/js/c377a04b.7ad684e9.js": "8671ab1f3a13d5c1ec67c261367b80b0",
"docs/assets/js/c377a04b.bb218ceb.js": "0b5627564036d87f5143296ed6a5f0cc",
"docs/assets/images/workout-programmer-program-analysis-828c1e824c3c855abd4c437a04f269a1.png": "ba68d805fed7d65f857d0480337c1518",
"docs/assets/images/workout-programmer-6258cf005d8e03b604e3ebaf626bfada.png": "71477f9cb14fefcb4fbe296dd0173f5f",
"docs/assets/images/dieter-menno-f89418d879626e6792eaf76e6f73d166.jpg": "752a4c7ca1883f47297b9022803680cb",
"docs/assets/images/workout-programmer-setup-7ace2157f88517fe69af676892b0dcbe.png": "57da5a0871454e424f10e32a9be049fe",
"docs/assets/images/workout-programmer-add-set-1fc62f6acb3fa17d51a414e806538e66.png": "7723c601052786c1944d5bf9758a5018",
"docs/assets/css/styles.17275f4c.css": "7b1ace6dd9269c60e82ca1715c0016e3",
"docs/sitemap.xml": "25dd5a702eb2c29f2b40aa6da2da1e93",
"img/body.build-program-builder.png": "b5d75845042ace756b3c54552513ab91",
"img/body.build-modifiers.png": "b9d50cee609116e093ff64b9a43ac159",
"img/body.build-volume-targets.png": "94934792f9481949e5b051adaee700d4",
"img/body.build-advanced-coverage.png": "18fdf5fde466b8748eed8d03cb854d89",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"css/style.css": "820e594d821e66d3b7678552e035e32c",
"index.html": "a6ca47dac4eb7d7181e796e2084ab0a7",
"/": "a6ca47dac4eb7d7181e796e2084ab0a7",
"404.html": "8054b0b53c72922735c2cd3bc4c653df",
"main.dart.js": "b40462e090ca610272c129c5059f7a01",
"app/manifest.json": "44ccc512e6e4d26e60a1a660a880fd7d",
"app/flutter_bootstrap.js": "050b3e30d336859a2d3788678bbe6a94",
"app/canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"app/canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"app/canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"app/canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"app/canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"app/canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"app/canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"app/canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"app/canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"app/canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"app/canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"app/canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"app/canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"app/canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"app/canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"app/index.html": "9aacd129305505cdeafe0eda0a2cd292",
"app/main.dart.js": "ada39848680b7ae88b72df20c39888ab",
"app/flutter.js": "888483df48293866f9f41d3d9274a779",
"app/version.json": "4c0b0c154c30e04bced0efa1e5a84849",
"app/assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"app/assets/fonts/MaterialIcons-Regular.otf": "2f0a39a8547f61fb526e0e6e2650c0ee",
"app/assets/AssetManifest.bin": "903e1e48ab77e0b5371fd2c6285280e7",
"app/assets/AssetManifest.json": "83dde1e585e098dfc2df4174e30591c4",
"app/assets/AssetManifest.bin.json": "ebab0d6ee713af7f503999a7c00d7ca2",
"app/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"app/assets/NOTICES": "03ef23b34479b9adeaef0b8475cb7149",
"app/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"app/assets/assets/images/logo_text.svg": "d53d4f7cf0af250430d3836b3821c6e3",
"app/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"app/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"app/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"app/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"app/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"version.json": "4c0b0c154c30e04bced0efa1e5a84849",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "2f0a39a8547f61fb526e0e6e2650c0ee",
"assets/AssetManifest.bin": "903e1e48ab77e0b5371fd2c6285280e7",
"assets/AssetManifest.json": "83dde1e585e098dfc2df4174e30591c4",
"assets/AssetManifest.bin.json": "ebab0d6ee713af7f503999a7c00d7ca2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/NOTICES": "f72756c87ec9ca3499d04406ac0102c6",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/images/logo_text.svg": "d53d4f7cf0af250430d3836b3821c6e3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"};
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
