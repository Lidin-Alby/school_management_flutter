'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "72c4ce249322d3fa135a50b830f69237",
".git/config": "af881f10b8d66fb12d83a539fc94c108",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "f7cec6b58baad37139c756bca6af47d4",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "028c2cd53cecae5e54a5a04676d74c5a",
".git/logs/refs/heads/main": "5c21c5ca9c3e72f37cab28a6d41ce8a9",
".git/logs/refs/remotes/origin/main": "533cc8d1f95032a5ac8c998c46423cd2",
".git/objects/02/a15477baa6049631ad81178673500eaef63ba4": "d74dd32e334de7847885d8d109893e18",
".git/objects/03/b5c3e18c9877d2f83736cda170605f3798aefa": "56ee463afed1566b2d2028199791d343",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/0d/c221b9f934c2cd722b28853002675c4f955e80": "6ad28242dcdf2dbe3d7330bc31179d0f",
".git/objects/10/add24d4c4a94811ab36c1e2222fc4fb9a235df": "7b325aecc15fd9b1163aabd569d1d412",
".git/objects/11/803cb041c4c5cdf4f86624e531d1d3fd775ba6": "5cf792ef06b0ca0248cd772c39e4b589",
".git/objects/16/100ef543106355605e8699ecd8775e3279970e": "b3c020491fdbd5f3947f711e239b09c3",
".git/objects/16/14dd40c0686f925debccc115e6aeb25941541d": "60e4bae2c5ecb185bc2f25d09a85adeb",
".git/objects/18/eab1c9bbb5d283821acc73a73f1f6e58dbb421": "97838a4439f2805af6841a0b1d2c80d1",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/27/54daefe4d5847a71f67e2a50264c512c4ad9ff": "3ac276b54f31314fac50b481da3b21d3",
".git/objects/29/caa4ef0a829d6076c852db0784ffc13d08dfec": "8ff935dc7e930c7004a4bb1c50ccc40e",
".git/objects/2a/1fb669912b6817ea71d724c9e219f20f51ac96": "0255db2773a1a8797fc2e26f55672b71",
".git/objects/2a/a4b72a52843cc59b5ce88edf5bb587762c1cd3": "ad20eaf3b6b41558ac45358087a106a2",
".git/objects/2b/2056961850cd8a1ed7d802d6ecd466061f5f40": "d3fc0ee7ab7377f24d11f23b277bc468",
".git/objects/2c/9f2cd4b7bfc6359096675430fb308ab5afd360": "bb8bc591250e453b2cba48932071e737",
".git/objects/2e/9103c302da63526d04c364d0042d3c576069cd": "aa79d2f9195fcf3e72ccd60ad95781b9",
".git/objects/2f/93bba89b00154d5b30c038bf325f8bd68fb505": "428d7faf81ddfb689c452b82164a92c6",
".git/objects/31/f415f12f3af84d1dafc5e965cb7a20f13c5544": "b0268b78c94a9b49ca7c380229736476",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/33/4b6791c6bce3b27ffcf845e10f8d8198bf4178": "0eee253218439e5ebf5196e9d724b366",
".git/objects/35/2dfd74fd0add995dc511f410bfe4aec789393e": "82fae8eb368b45285f4091547c8ac18f",
".git/objects/36/9cda7efacaa5fba10775e9a363936621b8e8e2": "e35a6ff1a6e6f972b11c5c617f63f03b",
".git/objects/3a/50bcf246953eac45889af16d2b3677deda2eba": "8088ab04e577ee09b6b83d07fe7586ee",
".git/objects/3a/5cdafd25340151a558a0c7641b1d3ae43683de": "1a92985d101a8251a3d09a7392766e46",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/3c/44dc8d3164d59d4f017a25acf7e9547b723890": "7d58b8a2afad26f0107d85cdbf4f420d",
".git/objects/3d/ee9ca386aac534ec40a4bdaa58b1aab9d56504": "9be3f453ef2c1d56090f5622ae0c43fc",
".git/objects/40/0d5b186c9951e294699e64671b9dde52c6f6a0": "f6bd3c7f9b239e8898bace6f9a7446b9",
".git/objects/42/75722d9de01ab9bae8fe2f0011635c20f91d7f": "c02e7d91088e5b95849a37ea5371efe6",
".git/objects/42/cb839350134493058f9ed7edae61b12859fc17": "33342f6e3cbf596bbe2115161149ee5d",
".git/objects/43/111bf370fa9f41085a5cc75dc74a02b7100515": "9857b5fbf425fffe75ba3de7ab2010c8",
".git/objects/44/5ce25731078d77b430ad4058954094ab8f1f46": "29289ed803c58bd1dbaafc892f5d59d5",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/47/e665e7f65e0aade92ad3858002e9814fc7cefb": "e826043adf8bd954025c76e133f8a0a6",
".git/objects/48/c9ff08972d787ec313fa1c3ef082ec134a607b": "c2f909f63c4d1a6dc4b2b3b5bde01ef1",
".git/objects/4b/c963a10a35deba43b631df2bb6990adf9cf640": "e583f41599538b6eb419d5d59c24609b",
".git/objects/4c/434e0bd5029ea43024fb363a670f7c5d175110": "a84790c477ac00d0d95abbafd9e40da1",
".git/objects/54/ba1460e69ae03417a509c734dc4599e332dda1": "2ef1e0874dc8e930990fd96a72d3d9ed",
".git/objects/5f/4c82062f5fd1b475a11a13ec2484f26fbb4de4": "31c8c28654fb461600d68f9c7a3fee7b",
".git/objects/5f/8a4e0e1225a110dff28f7a3d9ecce2a24ef8a5": "fd40ec6946b8dcf0356d2e104a15dbfb",
".git/objects/61/4661230e02e63f7b83a8b31a5f40528bf5c107": "19b8763474274cad76e2fed04ed20e9a",
".git/objects/62/28f86cc387a904e76c5bde3a37851623f31247": "72d343c9a366314b4d7ce2aa73c7c37c",
".git/objects/65/9bce89647e80ad94bf8be7620e1bc19422d2a8": "ed37b19acc176e5cabdb5296535f783b",
".git/objects/66/a7f245df670defca93617d88433ba080c56aed": "e6060661da0df43eb20d19347acac84d",
".git/objects/6a/4e3c8d136c3cf809788a3280fe12896d2d7800": "2d4b4bf2af5e13ec7522379bd9b54a82",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/6c/6eb78cdf1dc71ceafd915575196f49fe2a1aa0": "504e442bd76d4cc854b1df2e426a8bc4",
".git/objects/71/996f51e015ed6fd75d6ae19f209b5bef9d9a1f": "79d42c9f8b1af50e88174a0c5688d606",
".git/objects/71/b7d6b0f15aaf446dae00410614894dbacaea64": "4d425f0aaaa0d72731f693ed7f7801bc",
".git/objects/78/685b89b032f9e88895bd598ea105e1465b3696": "1983429e4cdcf57f9b440e248fac97c7",
".git/objects/7c/02c5217c64c53970bb0bd13aae395b86984a8c": "d4d698254fdb74e7bb21760ee439da0f",
".git/objects/80/98f02ffd808536c0015fad6e53f57417d46491": "23411ec1193a98a73139072f92cf0af4",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/86/3deabec45db58270d84a22da32cbff087c6409": "1dda850835d020cbb9d0d799438243c5",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/88/dd328a8262f5d962887e6f8c965498dddd4f97": "ac5d7b9a6c5a588313c708dc07d29bba",
".git/objects/89/31bdf9e7d588ab067e97209c316e2724af0084": "4abb56b1f83a5830b86447cdae4fe3fc",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/98/f608ea764bbd1b6f9db7b07798443c69ac1739": "fcfbad88a8334b946b3b059409d45ff9",
".git/objects/9a/eea623e5fa422187c4da9873baf65f4168b7d5": "ab1d9bc988e930f03f16f890a03595aa",
".git/objects/9b/21f83066989e03933807478cd70aca458fe5d0": "5c54f5931d88a1175ad15f0b8805d21a",
".git/objects/9d/6741b9c57b7cc6101edb99fabc6dc8eeececcf": "01d413faa2058aadeec24ae949d69ce7",
".git/objects/9d/9bc5b3f11e441e1e9077f416ba2d6646434234": "e780507cd2fac7c6277cdee6931dea36",
".git/objects/9e/f3446dd1cf8163005266c098996bcb3826fe05": "2393ef4dd5ff46690a9adaa8a5946a13",
".git/objects/9f/824373afe8e9f426735d909a1bbba55048f979": "580460b07073e246c5e2c9389ec48569",
".git/objects/a8/52de49b8b6f1bd537a7622ca18c3b152ed0915": "0dbd663d53cd4534665990d83f490dd4",
".git/objects/a8/746d3a628f6bc9a976dd5518e42d52346d94e3": "2f66a57a1a6d2ec6651454cbd0615de9",
".git/objects/a9/921f86aa3c36212bed344e7ec45c244f65b6e1": "5d147cc76e47f38567dd4ed3957a852c",
".git/objects/ac/518cee07a2495c94dd3ef163ab0a83184743a7": "a404c068287d4b87cb41ff53022789e2",
".git/objects/b0/8241a73a37887bb7ee73ecec2973329f6bec31": "b5411f975ff308109fed947446828d1f",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/bd/408cb9be7831d4910f4524bea9f219a57477c2": "5e1e332e9b0aaccf38bd4926fbf92807",
".git/objects/bd/a2bfe7dba6759791a9af0edcc35391a6a55010": "23d9e3c47377baa398a60631cc68f52e",
".git/objects/bf/ca38e39ce1d6cbad2add6914377ed724fc70bd": "8b19aef1ec0e1586b531231904250861",
".git/objects/bf/ce4a207f9827112395d52e59d15c7f249bd047": "754fd7cb726d118b567aea056f24f8a1",
".git/objects/c0/8c87792d7a68ffd71898fa598b9b983f7e7ef9": "f455d63cfccab304798020f3d589d259",
".git/objects/c2/e5cbdf81aea07d3ff6290b10995a643b8d6c45": "1f14b712cccb2572cd3b48d4ee9164de",
".git/objects/c5/d6d822b13dc40d94ea26b5bf53214854b239cc": "1ba55e99572769cf8723917ced07507a",
".git/objects/c6/c779a882dd3c08d8ff3e4fb967ebd25500a7c4": "92fdc638b5d9b20ef901aa117b1b1777",
".git/objects/cc/e306d6e7a45cca761819e82eaf4871d3f1dd26": "ec39624622c1e840e6582e38e69d2381",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/bb50b3c3bc534b51ba035a5e8495ba7af5025b": "81d30e6f235d2cd1960b1a0d917b3043",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/e1/7a77b36f9f9d04e7f3395a0fe59aee132e1b49": "2c47940c5b7305c300511a1aca3d3da8",
".git/objects/e3/38c9474bae2d21979b3700ba479297802e23d8": "1221828beff9256cf2e95ee3b386d16a",
".git/objects/e3/4730ae967da26537abf4b3481ae7fcbade3670": "605a038d8522093f32a9895a4011043e",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/aaa9103467350aed2b2676284fb18b617e84b4": "24427ee7762a062dec8e7261892480d6",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/6eb9d5244b28197ffd1a26461b48b5994a14fa": "7d25df25fc3d8d6137757d24c8ef8c42",
".git/objects/f3/b7006fd288cd7ac8a719d1f4bb6decf9217e01": "e1c20fc538f27e7f2d98df12e7e6831e",
".git/objects/fa/e23029b99446e0c0c93b01989b5c17f80c36de": "f631d30b4696ae3f7a94cd533200a5df",
".git/objects/fd/2f0d7aaa96b65373405de95f552111ec052dab": "911b7967a66095b64b0be368c4d2cca0",
".git/objects/fd/fad4cac9f1e0cd075837f9f7c0df3e8c6c827c": "b6b6486a480ac9f73ac9f56dba386855",
".git/refs/heads/main": "3f3b8bf23e5cc627834cda9d5528bcc1",
".git/refs/remotes/origin/main": "3f3b8bf23e5cc627834cda9d5528bcc1",
"assets/AssetManifest.bin": "491a405212b550771a5602cc0049668e",
"assets/AssetManifest.bin.json": "94f9da97552331490e7b1aeac3a1b820",
"assets/AssetManifest.json": "95bbbe61627c84219fda048b6641e2c1",
"assets/assets/image_asset.jpg": "4a61f8fe3fec9c2a2a6de086936175d3",
"assets/assets/profile.jpg": "5b054545af7cf1bf1634cbbd64ec99f3",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "9e0cd69c59a5f7375911592441d10453",
"assets/NOTICES": "45f6731ee7305da351b505bc6230ecb2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "362e62a0225c229d52b21f7b268dfb99",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "a54b64e04dd5ef32738f60a2a1cf73fc",
"/": "a54b64e04dd5ef32738f60a2a1cf73fc",
"main.dart.js": "bf5984e82abe6fb094fe727300699ce6",
"manifest.json": "a86d7cf2ba3dca9d48fa4cb7802a4ad1",
"README.md": "09db431299e915cf44403eb719e9a895",
"version.json": "230b47caf1b9b3ba06505099eeb4846f"};
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
