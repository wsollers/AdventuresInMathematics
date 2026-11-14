/* Check every inline TeX expression with exactly the KaTeX version shipped on the web. */
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import {createRequire} from "node:module";
const require = createRequire(import.meta.url);
const katex = require(process.env.KATEX_PATH || "katex");
const root = path.resolve(import.meta.dirname, "../../content/ordered-fields");
const manifest = JSON.parse(fs.readFileSync(path.join(root, "manifest.json"), "utf8"));
const cards = manifest.stages.flatMap(s => JSON.parse(fs.readFileSync(path.join(root, s.file), "utf8")));
test("all card math is KaTeX-compatible", () => {
  const bad = [];
  for (const card of cards) {
    for (const field of ["front", "back", "explanation"]) {
      const text = card[field];
      if (typeof text !== "string") continue;
      const pieces = text.split("$");
      if (pieces.length % 2 === 0) bad.push(card.id + " unbalanced dollars");
      for (let i=1;i<pieces.length;i+=2) {
        if (!pieces[i]) continue;
        try { katex.renderToString(pieces[i], {throwOnError:true,trust:false,strict:"ignore"}); }
        catch (err) { bad.push(card.id + " " + field + ": " + err.message); }
      }
    }
  }
  assert.deepEqual(bad, []);
});
