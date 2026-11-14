#!/usr/bin/env python3
"""Validate the public Foundations deck, coverage, source IDs, KaTeX delimiters and unlock DAG."""
import json
import pathlib
import re
from jsonschema import Draft202012Validator

root = pathlib.Path(__file__).resolve().parent
repo = root.parents[2]
def read(name):
    return json.loads((root / name).read_text(encoding="utf-8"))

manifest = read("manifest.json")
schema = read("schema.json")
coverage = read("coverage.json")
unlocks = read("unlock-levels.json")
Draft202012Validator.check_schema(schema)
validator = Draft202012Validator(schema)

cards = []
for stage in manifest["stages"]:
    data = read(stage["file"])
    errors = sorted(validator.iter_errors(data), key=lambda err: tuple(map(str, err.path)))
    if errors:
        raise ValueError(stage["file"] + ": " + errors[0].message)
    assert [c["id"] for c in data] == stage["card_ids"], stage["file"]
    assert all(c["stage"] == stage["stage"] for c in data), stage["file"]
    cards.extend(data)

ids = [c["id"] for c in cards]
assert len(ids) == len(set(ids)), "duplicate IDs"
assert ids == [c["id"] for c in manifest["cards"]], "manifest order drift"
byid = {c["id"]: c for c in cards}
for c in cards:
    assert re.fullmatch(r"aim\.orderedfields\.0[0-8]\.[a-z0-9-]+", c["id"]), c["id"]
    assert c["front"].strip() and c["back"].strip()
    for field in ("front", "back"):
        body = c[field]
        assert body.count("$") % 2 == 0, (c["id"], field, "unbalanced math")
        assert body.count("{") == body.count("}"), (c["id"], field, "unbalanced braces")
        assert "<script" not in body.lower(), c["id"]
    assert c["source"]["tex"] == "output/pdf/ordered_field_reference.tex"
    assert c["source"]["lean"] == "Aim/Analysis/Numbers.lean"
    assert all(p in byid and byid[p]["stage"] <= c["stage"] for p in c["prerequisites"])

visited, active = set(), set()
def walk(id):
    if id in active:
        raise ValueError("Circular card prerequisites at " + id)
    if id in visited:
        return
    active.add(id)
    for p in byid[id]["prerequisites"]:
        walk(p)
    active.remove(id)
    visited.add(id)
for id in ids:
    walk(id)

levelids = [level["id"] for level in unlocks["levels"]]
assert len(set(levelids)) == len(levelids), "duplicate level IDs"
levelmap = {level["id"]: level for level in unlocks["levels"]}
assert all(id in levelmap for id in unlocks["default_unlocked"]), "unknown default unlock"
assigned = [id for level in unlocks["levels"] for id in level["card_ids"]]
assert len(set(assigned)) == len(assigned), "card assigned to multiple levels"
assert set(assigned) == set(ids), "unlock levels missing cards or naming extra cards"
lvisited, lactive = set(), set()
def levelwalk(id):
    if id in lactive:
        raise ValueError("Circular unlock prerequisites at " + id)
    if id in lvisited:
        return
    assert id in levelmap, "unknown unlock dependency: " + id
    lactive.add(id)
    for dep in levelmap[id].get("requires", []):
        levelwalk(dep)
    lactive.remove(id)
    lvisited.add(id)
for id in levelids:
    levelwalk(id)

for entry in coverage["tex_rows"]:
    assert entry["card_ids"], "unmapped TeX row: " + entry["label"]
    assert all(id in byid for id in entry["card_ids"])
assert len(coverage["tex_rows"]) == 70, "reconcile against the TeX reference before changing row count"

excluded = {e["declaration"] for e in coverage.get("excluded_declarations", [])}
for entry in coverage["lean_declarations"]:
    if entry["card_ids"]:
        assert all(id in byid for id in entry["card_ids"])
    else:
        assert entry["declaration"] in excluded, "unexplained missing Lean mapping: " + entry["declaration"]

for rel in ("output/pdf/ordered_field_reference.tex", "Aim/Analysis/Numbers.lean"):
    assert (repo / rel).is_file(), rel + " not found in checked out repository"
print(
    f"PASS: {len(cards)} cards, {len(manifest['stages'])} stages, "
    f"{len(coverage['tex_rows'])} TeX rows, {len(levelids)} manual unlock levels; "
    "IDs and dependency graphs valid"
)

