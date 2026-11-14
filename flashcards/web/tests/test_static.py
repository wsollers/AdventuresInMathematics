#!/usr/bin/env python3
"""Smoke-check the static flashcard UI contract without requiring a browser."""
from html.parser import HTMLParser
import pathlib
import re

root = pathlib.Path(__file__).resolve().parents[1]
html = (root / "index.html").read_text(encoding="utf-8")
app = (root / "app.mjs").read_text(encoding="utf-8")
css = (root / "flashcards.css").read_text(encoding="utf-8")
class IDs(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = []
    def handle_starttag(self, tag, attrs):
        self.ids.extend(value for k, value in attrs if k == "id")
parser = IDs()
parser.feed(html)
assert len(parser.ids) == len(set(parser.ids)), "duplicate HTML ID"
referenced = set(re.findall(r'\$\("([a-z0-9-]+)"\)', app))
assert referenced.issubset(set(parser.ids)), "missing HTML IDs: " + str(referenced - set(parser.ids))
required = ("#main", "data-github-activity", "decks/ordered-fields")
assert 'href="#main"' in html, "skip navigation missing"
assert "renderMathInElement" in app, "KaTeX rendering missing"
assert "localStorage" in app and "exportProgress" in app, "local backup not implemented"
assert "serviceWorker" in app, "offline progressive enhancement missing"
assert "fetch(" in app and "no-cache" in app, "deck loading missing"
assert "min-height:45px" in css, "tablet tap targets reduced"
assert "/assets/css/site.css" in html, "site theme integration missing"
assert "data-github-activity" not in html, "flashcard app shouldn't duplicate homepage activity widget"
print(f"PASS: {len(parser.ids)} unique elements, {len(referenced)} DOM bindings, static UI contracts valid")

