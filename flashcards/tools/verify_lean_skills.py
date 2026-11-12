#!/usr/bin/env python3
"""Validate card structure and compile every canonical and alternative proof.
Run from repository root: python3 flashcards/tools/verify_lean_skills.py
Requires the toolchain in lean-toolchain and lake executable.
No personal review state is read or written.
"""
import argparse
import json
import pathlib
import re
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
CONTENT = ROOT / "flashcards/content/lean-skills"
REPORT = ROOT / "flashcards/reports/numbers-lean-skills-verification.json"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--skip-compile", action="store_true", help="Structural validation only; never marks cards verified")
    args = parser.parse_args()
    manifest = json.loads((CONTENT / "manifest.json").read_text())
    cards = [card for group in manifest["categories"]
             for card in json.loads((CONTENT / group["file"]).read_text())]
    if len(cards) != manifest["card_count"]:
        raise SystemExit("Manifest count mismatch")
    ids = [card["id"] for card in cards]
    if len(ids) != len(set(ids)):
        raise SystemExit("Duplicate stable IDs")
    for card in cards:
        for field in ("id","question","expected_goal","context","canonical_answer","source","verification"):
            if not card.get(field):
                raise SystemExit(f"{card.get('id')}: missing {field}")
        if not re.fullmatch(r"LS-[A-Z]+-[0-9]{3}", card["id"]):
            raise SystemExit(f"Invalid ID: {card['id']}")
        if card["source"]["blob_sha"] != manifest["source"]["blob_sha"]:
            raise SystemExit(f"{card['id']}: source revision inconsistent")
    if args.skip_compile:
        print(f"Structure OK: {len(cards)} cards. Compiler verification NOT performed.")
        return 0
    prep = subprocess.run(["lake","build","Aim.Analysis.Numbers"],cwd=ROOT,text=True,capture_output=True)
    if prep.returncode:
        print("SOURCE BUILD FAILED; no card can be certified",file=sys.stderr)
        print((prep.stderr or prep.stdout)[-5000:],file=sys.stderr)
        return 2
    results = []
    with tempfile.TemporaryDirectory(prefix="lean-skills-") as td:
        for card in cards:
            candidates = [card["canonical_answer"],*card["alternative_accepted_answers"]]
            for ix, answer in enumerate(candidates):
                if re.search(r"\b(sorry|admit)\b",answer):
                    results.append({"card_id":card["id"],"variant":ix,"status":"failed","diagnostic":"sorry/admit forbidden"})
                    continue
                code = "import Aim.Analysis.Numbers\nopen aim.analysis\nuniverse u\n\nexample " + card["context"] + " :\n    " + card["expected_goal"] + " := by\n" + "\n".join("  "+s for s in answer.splitlines()) + "\n"
                path = pathlib.Path(td)/("card_"+card["id"].replace("-","_")+"_"+str(ix)+".lean")
                path.write_text(code)
                proc = subprocess.run(["lake","env","lean",str(path)],cwd=ROOT,text=True,capture_output=True)
                msg=(proc.stdout+"\n"+proc.stderr).strip()
                # Imported source may contain warnings about existing sorry proofs.
                # Only warnings referring to THIS isolated test file are relevant.
                status = "verified" if proc.returncode==0 and not re.search(r"declaration uses 'sorry'|declaration uses 'admit'",msg) else "failed"
                results.append({"card_id":card["id"],"variant":ix,"status":status,"diagnostic":msg[:3000]})
                print(card["id"],"canonical" if ix==0 else "alternative "+str(ix),status)
    REPORT.parent.mkdir(parents=True,exist_ok=True)
    REPORT.write_text(json.dumps({"source_blob_sha":manifest["source"]["blob_sha"],"results":results},indent=2)+"\n")
    failures=[r for r in results if r["status"]!="verified"]
    print(f"Verified {len(results)-len(failures)}/{len(results)} proof candidates.")
    return 1 if failures else 0

if __name__ == "__main__":
    sys.exit(main())
