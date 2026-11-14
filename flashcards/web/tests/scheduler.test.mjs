import test from "node:test";
import assert from "node:assert/strict";
import { DAY, MINUTE, schedule, isDue, mayUnlock, selectCards, prerequisitesMet, stats } from "../scheduler.mjs";

const now = Date.parse("2026-11-14T12:00:00.000Z");
const c = (id, stage = 0, prerequisites = []) => ({id, stage, type:"axiom", prerequisites});
test("new ratings have different initial intervals", () => {
  assert.equal(Date.parse(schedule(null, "again", now).dueAt)-now, MINUTE);
  assert.equal(Date.parse(schedule(null, "hard", now).dueAt)-now, 10*MINUTE);
  assert.equal(Date.parse(schedule(null, "good", now).dueAt)-now, DAY);
  assert.equal(Date.parse(schedule(null, "easy", now).dueAt)-now, 4*DAY);
});
test("repetition and lapse bookkeeping is deterministic", () => {
  const a=schedule(null,"good",now);
  const b=schedule(a,"good",now+DAY);
  assert.equal(b.reviewCount,2);
  assert.ok(b.intervalMinutes>a.intervalMinutes);
  const c=schedule(b,"again",now+2*DAY);
  assert.equal(c.repetitions,0);
  assert.equal(c.lapses,1);
  assert.equal(c.reviewCount,3);
  assert.equal(a.reviewCount,1);
});
test("due time has inclusive boundary", () => {
  const card=schedule(null,"good",now);
  assert.equal(isDue(card,now+DAY-1),false);
  assert.equal(isDue(card,now+DAY),true);
  assert.equal(isDue(null,now+DAY),false);
});
test("unknown rating fails closed", () => {
  assert.throws(()=>schedule(null,"pass",now),RangeError);
});
test("a prerequisite requires actual study, not an unlocked level", () => {
  assert.equal(prerequisitesMet(c("proof",8,["axiom"]),{}),false);
  assert.equal(prerequisitesMet(c("proof",8,["axiom"]),{axiom:{reviewCount:1}}),true);
});
test("unlock order is explicitly controlled", () => {
  assert.equal(mayUnlock({requires:["first"]},new Set()),false);
  assert.equal(mayUnlock({requires:["first"]},new Set(["first"])),true);
});
test("new and due queues obey unlocked set, filter, seen, and prerequisites", () => {
  const cards=[c("a"),c("b"),c("c",8,["a"])];
  const available=new Set(["a","c"]);
  assert.deepEqual(selectCards(cards,{}, {mode:"new", available,now}).map(x=>x.id),["a"]);
  const reviews={a:schedule(null,"again",now-2*MINUTE)};
  assert.deepEqual(selectCards(cards,reviews,{mode:"new",available,now}).map(x=>x.id),["c"]);
  assert.deepEqual(selectCards(cards,reviews,{mode:"due",available,now}).map(x=>x.id),["a"]);
  assert.deepEqual(selectCards(cards,reviews,{mode:"due",available,seen:new Set(["a"]),now}),[]);
  assert.deepEqual(selectCards(cards,reviews,{mode:"browse",stage:"8",now}).map(x=>x.id),["c"]);
});
test("statistics exclude locked cards from review counts",()=>{
 const cards=[c("a"),c("b")], available=new Set(["a"]);
 const reviews={a:schedule(null,"again",now-MINUTE),b:schedule(null,"good",now)};
 const s=stats(cards,reviews,available,now);
 assert.deepEqual(s,{total:2,unlocked:1,studied:1,due:1,new:0});
});
