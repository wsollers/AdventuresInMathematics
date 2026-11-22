import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {indexCurriculum} from '../curriculum.mjs';
import {selectCards,levelCardIds} from '../scheduler.mjs';
const root=path.resolve(import.meta.dirname,'../../content');
const read=p=>JSON.parse(fs.readFileSync(path.join(root,p),'utf8'));
const curriculum=read('curriculum.json');
const cards=['ordered-fields','calculus','geometry'].flatMap(deck=>read(deck+'/manifest.json').stages.flatMap(s=>read(deck+'/'+s.file)));
const index=indexCurriculum(curriculum,cards);
test('curriculum order and assignments cover every stable card exactly once',()=>{
  assert.deepEqual(curriculum.subjects.slice(0,7).map(s=>s.id),['logic','geometry','analytic','vectors','sets','relations','functions']);
  assert.equal(index.cardTopics.size,909);
  for(const subject of curriculum.subjects)for(const topic of subject.topics)if(topic.future)assert.deepEqual(topic.card_ids,[]);
  assert.equal(index.selections.get('subject:sets').size,3);
  assert.equal(index.selections.get('subject:relations').size,6);
  assert.equal(index.selections.get('subject:functions').size,3);
  assert.ok([...index.selections.get('topic:derivative-rules')].includes('aim.calculus.calculus-rules.power'));
  assert.ok([...index.selections.get('topic:standard-derivatives')].includes('aim.calculus.trig-calculus.d-sin'));
});
test('subject and topic filters do not bypass unlocks or prerequisites',()=>{
  const selection=index.selections.get('subject:relations');
  assert.equal(selectCards(cards,{}, {mode:'browse',selection}).length,6);
  assert.equal(selectCards(cards,{}, {mode:'new',selection}).length,0);
  assert.equal(selectCards(cards,{}, {mode:'browse',selection:new Set()}).length,0);
  const levels=read('geometry/unlock-levels.json');
  const available=levelCardIds(levels.levels,new Set(levels.default_unlocked));
  assert.equal(selectCards(cards,{}, {available}).length,239);
});
test('new geometry and vector content has valid manifests and no prerequisites on future theory',()=>{
  const manifest=read('geometry/manifest.json');
  const all=manifest.stages.flatMap(s=>{
    const group=read('geometry/'+s.file);assert.deepEqual(group.map(c=>c.id),s.card_ids);return group;
  });
  assert.equal(new Set(all.map(c=>c.id)).size,239);
  assert.deepEqual(all.map(c=>c.id),manifest.cards.map(c=>c.id));
  for(const card of all){
    assert.ok(card.front && card.back);assert.deepEqual(card.prerequisites,[]);assert.ok(!card.source.lean);
    assert.ok(!/[\x00-\x08\x0b\x0c\x0e-\x1f]/.test(card.front+card.back),card.id);
  }
});
