import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import {createRequire} from "node:module";
const require = createRequire(import.meta.url);
const {JSDOM} = require(process.env.JSDOM_PATH || "jsdom");

const webRoot = path.resolve(import.meta.dirname, "..");
const dataRoot = path.resolve(webRoot, "../content/ordered-fields");

test("study app loads real cards, reveals an answer and saves review locally", async () => {
  const html = fs.readFileSync(path.join(webRoot,"index.html"),"utf8");
  const dom = new JSDOM(html,{url:"https://wsollers.dev/AdventuresInMath/flashcards/",pretendToBeVisual:true});
  const win = dom.window;
  const original = {
    window: globalThis.window, document: globalThis.document,
    location: globalThis.location, localStorage: globalThis.localStorage,
    fetch: globalThis.fetch
  };
  const navigatorDescriptor = Object.getOwnPropertyDescriptor(globalThis,"navigator");
  try {
    globalThis.window = win;
    globalThis.document = win.document;
    globalThis.location = win.location;
    globalThis.localStorage = win.localStorage;
    Object.defineProperty(globalThis,"navigator",{value:win.navigator,configurable:true});
    globalThis.fetch = async url => {
      const pathname = new URL(String(url)).pathname;
      const marker = "/decks/ordered-fields/";
      assert.ok(pathname.includes(marker), "unexpected fetch: " + pathname);
      const relative = pathname.slice(pathname.lastIndexOf(marker) + marker.length);
      assert.ok(/^[a-z0-9-]+\.json$/.test(relative));
      const data = JSON.parse(fs.readFileSync(path.join(dataRoot,relative),"utf8"));
      return {ok:true,json:async()=>data};
    };
    await import("../app.mjs");
    for (let n=0;n<50 && win.document.getElementById("stat-total").textContent==="—";n++) {
      await new Promise(resolve=>setTimeout(resolve,10));
    }
    const $ = id => win.document.getElementById(id);
    assert.equal($("load-error").hidden,true, $("load-error").textContent);
    assert.equal($("stat-total").textContent,"375");
    assert.equal($("stat-new").textContent,"4");
    assert.equal($("card-category").textContent,"Stage 3 · axiom");
    assert.equal($("answer-section").hidden,true);
    $("reveal").click();
    assert.equal($("answer-section").hidden,false);
    assert.match($("card-back").textContent,/a.*b.*c/);
    win.document.querySelector('[data-grade="good"]').click();
    assert.equal($("stat-studied").textContent,"1");
    const stored=JSON.parse(win.localStorage.getItem("aim-foundations-review-v1"));
    assert.equal(stored.format,"aim-foundations-progress");
    assert.equal(Object.keys(stored.reviews).length,1);
    const mode=$("mode");mode.value="browse";mode.dispatchEvent(new win.Event("change",{bubbles:true}));
    const stage=$("stage");stage.value="0";stage.dispatchEvent(new win.Event("change",{bubbles:true}));
    assert.equal($("card-category").textContent,"Stage 0 · notation");
    $("reveal").click();
    assert.equal($("grade-panel").hidden,true,"browse must not schedule review");
    assert.equal($("browse-actions").hidden,false);
    $("browse-next").click();
    assert.equal($("stat-studied").textContent,"1","browse must not change review count");
  } finally {
    globalThis.window=original.window;
    globalThis.document=original.document;
    globalThis.location=original.location;
    globalThis.localStorage=original.localStorage;
    globalThis.fetch=original.fetch;
    if (navigatorDescriptor) Object.defineProperty(globalThis,"navigator",navigatorDescriptor);
    else delete globalThis.navigator;
    win.close();
  }
});
