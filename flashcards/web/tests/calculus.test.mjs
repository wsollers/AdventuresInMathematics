import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {selectCards, levelCardIds} from '../scheduler.mjs';

const root = path.resolve(import.meta.dirname, '../../content/calculus');
const read = file => JSON.parse(fs.readFileSync(path.join(root, file), 'utf8'));
const manifest = read('manifest.json');
const unlocks = read('unlock-levels.json');
const cards = manifest.stages.flatMap(s => read(s.file));

test('calculus topics have consistent IDs, levels and independently reviewable cards', () => {
  assert.equal(manifest.stages.length, 13);
  assert.equal(cards.length, 285);
  assert.equal(new Set(cards.map(c => c.id)).size, cards.length);
  assert.deepEqual(cards.map(c => c.id), manifest.cards.map(c => c.id));
  for (const stage of manifest.stages) {
    const group = read(stage.file);
    assert.deepEqual(group.map(c => c.id), stage.card_ids);
    assert.ok(group.every(c => c.stage === stage.stage && c.topic === stage.title));
  }
  for (const card of cards) {
    assert.match(card.id, /^aim\.calculus\.[a-z-]+\.[a-z0-9-]+$/);
    assert.ok(card.front.trim() && card.back.trim());
    assert.deepEqual(card.prerequisites, []);
    assert.ok(!card.source.lean, 'reference cards must not claim a Lean source');
    for (const field of ['front', 'back', 'explanation']) {
      assert.equal((card[field].match(/\$/g) || []).length % 2, 0, card.id);
      assert.ok(!/[\x00-\x08\x0b\x0c\x0e-\x1f]/.test(card[field]), card.id);
    }
  }
  const available = levelCardIds(unlocks.levels, new Set(unlocks.default_unlocked));
  assert.equal(available.size, cards.length);
  assert.equal(selectCards(cards, {}, {available}).length, cards.length);
});

test('angle conversions have separate cards in both directions', () => {
  const angles = cards.filter(c => c.topic === 'Degrees and radians');
  const forward = angles.filter(c => /\.deg-/.test(c.id));
  const reverse = angles.filter(c => /\.rad-/.test(c.id));
  assert.equal(forward.length, 17);
  assert.equal(reverse.length, 17);
  for (const card of forward) {
    const partner = reverse.find(c => c.id === card.id.replace('.deg-', '.rad-'));
    assert.ok(partner);
    assert.equal(card.back.match(/\$(.*?)\$/)[1], partner.front.match(/\$(.*?)\$/)[1]);
    assert.equal(card.front.match(/\$(.*?)\$/)[1], partner.back.match(/\$(.*?)\$/)[1]);
  }
});
