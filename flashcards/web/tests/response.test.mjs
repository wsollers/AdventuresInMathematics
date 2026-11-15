import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import {createRequire} from "node:module";
import {setupResponse} from "../response.mjs";
const require = createRequire(import.meta.url);
const {JSDOM} = require(process.env.JSDOM_PATH || "jsdom");
const html = fs.readFileSync(new URL("../index.html", import.meta.url), "utf8");

test("pen pad rejects palms, retains separate strokes, and resets between cards", () => {
  const dom = new JSDOM(html);
  try {
    const doc = dom.window.document, pad = doc.getElementById("answer-pad");
    pad.getBoundingClientRect = () => ({left:0, top:0, width:500, height:250});
    const response = setupResponse(doc, dom.window);
    function pointer(type, pointerType, pointerId, x = 20) {
      const event = new dom.window.Event(type, {cancelable:true});
      Object.assign(event, {pointerType, pointerId, button:0, clientX:x, clientY:30});
      pad.dispatchEvent(event);
    }
    pointer("pointerdown", "touch", 1);
    assert.equal(pad.children.length, 0);
    pointer("pointerdown", "pen", 2);
    pointer("pointerdown", "touch", 3);
    pointer("pointermove", "pen", 2, 40);
    pointer("pointerup", "pen", 2);
    assert.equal(pad.children.length, 1);
    assert.equal(pad.firstElementChild.getAttribute("points"), "40,60 80,60");
    pointer("pointerdown", "pen", 4);
    pointer("pointercancel", "pen", 4);
    doc.getElementById("undo-ink").click();
    assert.equal(pad.children.length, 1);
    doc.getElementById("answer-text").value = "My answer";
    response.reset();
    assert.equal(pad.children.length, 0);
    assert.equal(doc.getElementById("answer-text").value, "");
    assert.equal(doc.getElementById("speak-answer").disabled, true);
  } finally { dom.window.close(); }
});

test("voice appends dictation, stops on reset and ignores late results", () => {
  const dom = new JSDOM(html);
  try {
    let session;
    dom.window.SpeechRecognition = class {
      constructor() { session = this; }
      start() {}
      abort() { this.aborted = true; this.onend(); }
    };
    const doc = dom.window.document, text = doc.getElementById("answer-text");
    const response = setupResponse(doc, dom.window);
    text.value = "First";
    doc.getElementById("speak-answer").click();
    session.onresult({results: [[{transcript:"second"}]]});
    assert.equal(text.value, "First second");
    response.stop();
    assert.equal(text.value, "First second");
    assert.equal(text.readOnly, false);
    assert.equal(session.aborted, true);
    response.reset();
    session.onresult({results: [[{transcript:"stale answer"}]]});
    assert.equal(text.value, "");
    doc.getElementById("speak-answer").click();
    session.onerror({error:"not-allowed"});
    assert.match(doc.getElementById("voice-status").textContent, /denied/);
    assert.equal(doc.getElementById("speak-answer").getAttribute("aria-pressed"), "false");
  } finally { dom.window.close(); }
});
