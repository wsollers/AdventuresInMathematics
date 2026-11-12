#!/usr/bin/env python3
"""Validate deck JSON Schema, source mapping, IDs, prerequisites, and coverage.

Requires: pip install jsonschema
Run: python3 flashcards/content/ordered-fields/validate.py
"""
import json
import pathlib
import re
from jsonschema import Draft202012Validator

root = pathlib.Path(__file__).resolve().parent
read = lambda p: json.loads((root / p).read_text(encoding="utf-8"))
manifest, schema, coverage = read("manifest.json"), read("schema.json"), read("coverage.json")
Draft202012Validator.check_schema(schema)
validator = Draft202012Validator(schema)
cards = []
for stage in manifest["stages"]:
    data = read(stage["file"])
    errors = sorted(validator.iter_errors(data), key=lambda e: list(map(str, e.path)))
    if errors:
        raise ValueError(f"{stage['file']}: {errors[0].message}")
    assert [c["id"] for c in data] == stage["card_ids"], stage["file"]
    assert all(c["stage"] == stage["stage"] for c in data)
    cards.extend(data)
ids = [c["id"] for c in cards]
assert len(ids) == len(set(ids)), "duplicate card IDs"
assert ids == [c["id"] for c in manifest["cards"]], "manifest/card order mismatch"
byid = {c["id"]: c for c in cards}
for c in cards:
    assert re.fullmatch(r"aim\.orderedfields\.0[0-8]\.[a-z0-9-]+", c["id"]), c["id"]
    assert c["front"].strip() and c["back"].strip()
    assert c["source"]["tex"] == "output/pdf/ordered_field_reference.tex"
    assert c["source"]["lean"] == "Aim/Analysis/Numbers.lean"
    for field in ("front", "back"):
        text = c[field]
        assert text.count("$") % 2 == 0, (c["id"], field, "unbalanced math delimiters")
        assert text.count("{") == text.count("}"), (c["id"], field, "unbalanced braces")
    for p in c["prerequisites"]:
        assert p in byid, (c["id"], p)
        assert byid[p]["stage"] <= c["stage"], (c["id"], p, "future dependency")
visited, active = set(), set()
def visit(card_id):
    if card_id in active:
        raise ValueError("cyclic prerequisite dependency: " + card_id)
    if card_id in visited:
        return
    active.add(card_id)
    for prerequisite in byid[card_id]["prerequisites"]:
        visit(prerequisite)
    active.remove(card_id)
    visited.add(card_id)
for card_id in ids:
    visit(card_id)
for entry in coverage["tex_rows"]:
    assert entry["card_ids"] and all(i in byid for i in entry["card_ids"]), entry["label"]
for entry in coverage["lean_declarations"]:
    assert all(i in byid for i in entry["card_ids"]), entry["declaration"]
print(f"PASS: {len(cards)} cards, {len(coverage['tex_rows'])} TeX rows, 9 stages; JSON Schema and DAG valid")
