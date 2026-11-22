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
  const preservedId="aim.calculus.angles.deg-30";
  const preservedReview={reviewCount:7,repetitions:5,lapses:1,ease:2.5,intervalMinutes:1440,lastRating:"good",reviewedAt:"2026-11-20T12:00:00.000Z",dueAt:"2026-11-21T12:00:00.000Z"};
  const backup={format:"aim-foundations-progress",version:1,unlocked:["addition-axioms","calculus-angles"],reviews:{[preservedId]:preservedReview}};
  win.localStorage.setItem("aim-foundations-review-v1",JSON.stringify(backup));
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
    globalThis.fetch = async (url, options) => {
      const pathname = new URL(String(url)).pathname;
      if (pathname.endsWith("/api/grade")) {
        assert.equal(JSON.parse(options.body).text,"a plus b equals b plus a");
        return Response.json({verdict:"correct",rating:"good",reading:"a + b = b + a",feedback:"Correct commutativity statement.",missing:""});
      }
      if(pathname.endsWith('/decks/curriculum.json')) return Response.json(JSON.parse(fs.readFileSync(path.join(dataRoot,'../curriculum.json'),'utf8')));
      const deck = pathname.includes("/decks/calculus/") ? "calculus" : pathname.includes('/decks/geometry/') ? 'geometry' : "ordered-fields";
      const marker = "/decks/" + deck + "/";
      assert.ok(pathname.includes(marker), "unexpected fetch: " + pathname);
      const relative = pathname.slice(pathname.lastIndexOf(marker) + marker.length);
      assert.ok(/^[a-z0-9-]+\.json$/.test(relative));
      const data = JSON.parse(fs.readFileSync(path.join(dataRoot,"..",deck,relative),"utf8"));
      return {ok:true,json:async()=>data};
    };
    await import("../app.mjs");
    for (let n=0;n<50 && win.document.getElementById("stat-total").textContent==="—";n++) {
      await new Promise(resolve=>setTimeout(resolve,10));
    }
    const $ = id => win.document.getElementById(id);
    assert.equal($("load-error").hidden,true, $("load-error").textContent);
    assert.equal($("stat-total").textContent,"909");
    assert.equal($("stat-new").textContent,"527");
    assert.equal($("card-category").textContent,"Field axioms · axiom");
    assert.deepEqual(JSON.parse(win.localStorage.getItem('aim-foundations-review-v1')),backup,'loading the new curriculum must not rewrite existing progress');
    assert.equal($("answer-section").hidden,true);
    $("answer-text").value="a plus b equals b plus a";
    $("submit-answer").click();
    for(let n=0;n<50 && $("answer-section").hidden;n++) await new Promise(resolve=>setTimeout(resolve,10));
    assert.equal($("answer-section").hidden,false);
    assert.equal($("assessment-title").textContent,"Correct");
    assert.equal($("answer-text").value,"a plus b equals b plus a");
    assert.equal($("stat-studied").textContent,"1","assessment alone must not save a review");
    assert.match($("card-back").textContent,/a.*b.*c/);
    $("accept-assessment").click();
    assert.equal($("stat-studied").textContent,"2");
    const stored=JSON.parse(win.localStorage.getItem("aim-foundations-review-v1"));
    assert.equal(stored.format,"aim-foundations-progress");
    assert.equal(Object.keys(stored.reviews).length,2);
    assert.deepEqual(stored.reviews[preservedId],preservedReview,'existing due dates and review records must survive a new review');
    const mode=$("mode");mode.value="browse";mode.dispatchEvent(new win.Event("change",{bubbles:true}));
    const stage=$("stage");stage.value="topic:logic-language";stage.dispatchEvent(new win.Event("change",{bubbles:true}));
    assert.equal($("card-category").textContent,"Statements, notation and proof language · notation");
    $("reveal").click();
    assert.equal($("grade-panel").hidden,true,"browse must not schedule review");
    assert.equal($("browse-actions").hidden,false);
    $("browse-next").click();
    assert.equal($("stat-studied").textContent,"2","browse must not change review count");
    stage.value="topic:angles";stage.dispatchEvent(new win.Event("change",{bubbles:true}));
    assert.match($("card-category").textContent,/Degrees and radians/);
    $("reveal").click();
    assert.match($("card-back").textContent,/theta=s\/r/);
    stage.value="topic:coordinate-conversions";stage.dispatchEvent(new win.Event("change",{bubbles:true}));
    assert.match($("card-category").textContent,/coordinates/);
    mode.value="new";mode.dispatchEvent(new win.Event("change",{bubbles:true}));
    assert.equal($("study-actions").hidden,false,"new calculus topics are reviewable without unlocking Foundations");
    stage.value='topic:derivative-definitions';stage.dispatchEvent(new win.Event('change'));
    assert.equal($('card-front').textContent,'No cards yet');
    assert.equal($('study-actions').hidden,true);
    const relations=win.document.querySelector('[data-topic="relations-basics"]');
    relations.open=true;relations.dispatchEvent(new win.Event('toggle'));
    const lockedCard=relations.querySelector('[data-card-id="aim.orderedfields.01.relation"]');
    assert.ok(lockedCard,'individual card choices are available inside topic dropdowns');
    const beforeBrowse=win.localStorage.getItem('aim-foundations-review-v1');
    lockedCard.click();
    assert.equal(mode.value,'browse');
    assert.match($('card-front').textContent,/binary relation/);
    assert.equal($('response-workspace').hidden,true);
    assert.equal(win.localStorage.getItem('aim-foundations-review-v1'),beforeBrowse);
    mode.value='new';mode.dispatchEvent(new win.Event('change'));
    assert.equal($('study-actions').hidden,true,'browsing a locked card must not unlock it for review');
    stage.value='topic:geometry-circles';stage.dispatchEvent(new win.Event('change'));
    mode.value='browse';mode.dispatchEvent(new win.Event('change'));
    const circles=win.document.querySelector('[data-topic="geometry-circles"]');
    circles.open=true;circles.dispatchEvent(new win.Event('toggle'));
    circles.querySelector('[data-card-id="aim.geometry.circles.tangent"]').click();
    assert.equal($('card-diagram').hidden,false);
    assert.match($('card-diagram').textContent,/Tangent at T/);
    assert.equal($('card-diagram').querySelectorAll('svg').length,1);
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
