/* Retire offline app caching now that flashcards require ChatGPT authorization. */
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(key => key.startsWith("aim-foundations-web-")).map(key => caches.delete(key)));
    await self.registration.unregister();
    await self.clients.claim();
  })());
});
// No fetch handler: every request goes to the server authorization boundary.
