#!/usr/bin/env python3
import json,pathlib,re
p=pathlib.Path(__file__).parent
m=json.loads((p/"manifest.json").read_text())
cards=[c for s in m["stages"] for c in json.loads((p/s["file"]).read_text())]
ids=[c["id"] for c in cards]; assert len(ids)==len(set(ids))
assert ids==[c["id"] for c in m["cards"]]
byid={c["id"]:c for c in cards}
for c in cards:
 assert set(["id","type","stage","topic","difficulty","front","back","source","prerequisites","tags"])<=set(c)
 assert re.fullmatch(r"aim\.orderedfields\.0[0-8]\.[a-z0-9-]+",c["id"])
 assert c["front"].strip() and c["back"].strip()
 for text in (c["front"],c["back"]):
  assert text.count("$")%2==0,(c["id"],text)
 for pre in c["prerequisites"]:
  assert pre in byid and byid[pre]["stage"]<=c["stage"]
seen=set();active=set()
def visit(k):
 if k in active: raise ValueError("cycle: "+k)
 if k in seen:return
 active.add(k)
 for x in byid[k]["prerequisites"]:visit(x)
 active.remove(k);seen.add(k)
for k in ids:visit(k)
report=json.loads((p/"coverage.json").read_text())
assert all(x["card_ids"] for x in report["tex_rows"])
print("PASS",len(cards),"cards",len(report["tex_rows"]),"TeX rows")
