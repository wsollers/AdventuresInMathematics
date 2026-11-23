#!/usr/bin/env python3
"""Check the Lean sources against Aim/Common/conventions.json.

    python scripts/check_conventions.py

Every rule in the JSON file marked "enforced" has a check here, and every
check here has a rule there; a mismatch is itself an error. The checks read
the text of the files. They do not run Lean.
"""
import json
import pathlib
import re
import subprocess
import sys

REPO = pathlib.Path(__file__).resolve().parent.parent
SOURCE = REPO / "Aim" / "Common" / "conventions.json"

PROOF_KEYWORDS = ("theorem", "lemma", "corollary", "proposition", "named_exercise",
                  "exercise", "counterexample", "example")
DECL_KEYWORDS = PROOF_KEYWORDS + ("def", "abbrev", "class", "structure", "inductive",
                                  "instance", "opaque", "axiom", "syntax", "macro",
                                  "macro_rules", "notation", "infix", "infixl", "infixr",
                                  "prefix", "postfix")
MODIFIERS = r"(?:(?:private|protected|noncomputable|scoped|local|unsafe|partial)\s+)*"
ATTRIBUTE = r"(?:@\[[^\]]*\]\s*)*"
DECL_RE = re.compile(r"^\s*" + ATTRIBUTE + MODIFIERS + r"(" + "|".join(DECL_KEYWORDS) + r")\b", re.M)
PROOF_RE = re.compile(r"^\s*" + ATTRIBUTE + MODIFIERS + r"(" + "|".join(PROOF_KEYWORDS) + r")\b", re.M)
TYPE_RE = re.compile(r"^\s*" + ATTRIBUTE + MODIFIERS + r"(?:class|structure|inductive|def|abbrev)\s+([A-Z]\w*)", re.M)
SET_TYPES = r"(?:Aim\.|_root_\.)?(?:Set|Collection|Family)\b"


def lean_files(*roots):
    listed = subprocess.run(["git", "ls-files", "-co", "--exclude-standard", "--", *roots],
                            cwd=REPO, capture_output=True, text=True, check=True).stdout.split("\n")
    return sorted(p for p in listed if p.endswith(".lean") and "/.lake/" not in p)


def strip_comments(text):
    """Replace comments by spaces, keeping line structure. Block comments nest."""
    out = []
    i, depth, n = 0, 0, len(text)
    while i < n:
        two = text[i:i + 2]
        if two == "/-":
            depth += 1
            out.append("  ")
            i += 2
        elif two == "-/" and depth:
            depth -= 1
            out.append("  ")
            i += 2
        elif depth:
            out.append("\n" if text[i] == "\n" else " ")
            i += 1
        elif two == "--":
            while i < n and text[i] != "\n":
                out.append(" ")
                i += 1
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def line_of(text, index):
    return text.count("\n", 0, index) + 1


def excepted(rule, path):
    return any(path == e["path"] or (e["path"].endswith("/") and path.startswith(e["path"]))
               for e in rule["exceptions"])


# ------------------------------------------------------------------ checks

def check_tactic_proofs(rule, sources):
    problems = []
    for path, code in sources.items():
        for match in PROOF_RE.finditer(code):
            depth, i = 0, match.end()
            while i < len(code):
                char = code[i]
                if char in "([{⟨⦃":
                    depth += 1
                elif char in ")]}⟩⦄":
                    depth -= 1
                elif depth == 0 and code.startswith(":=", i):
                    rest = code[i + 2:].lstrip()
                    if not re.match(r"by\b", rest):
                        problems.append(f"{path}:{line_of(code, match.start(1))}: "
                                        f"`{match.group(1)}` is not proved with a `by` block")
                    break
                elif depth == 0 and i > match.end() and DECL_RE.match(code, code.rfind("\n", 0, i) + 1) \
                        and code.rfind("\n", 0, i) + 1 > match.start():
                    break  # reached the next declaration without finding `:=`
                i += 1
    return problems


def check_aggregator_naming(rule, sources):
    problems = []
    for path, code in sources.items():
        if not path.startswith("Aim/"):
            continue
        folder, name = pathlib.PurePosixPath(path).parent.name, pathlib.PurePosixPath(path).stem
        if name.endswith("Aggregator"):
            if name != folder + "Aggregator":
                problems.append(f"{path}: an aggregator must be named {folder}Aggregator.lean")
            body = "\n".join(line for line in code.splitlines() if not line.startswith("import "))
            if body.strip():
                first = next(n for n, line in enumerate(code.splitlines(), 1)
                             if line.strip() and not line.startswith("import "))
                problems.append(f"{path}:{first}: an aggregator contains only imports and a docstring")
        elif name == folder and not excepted(rule, path) and not DECL_RE.search(code)                 and re.search(r"^import ", code, re.M):
            problems.append(f"{path}: this file only re-exports its folder; name it {folder}Aggregator.lean")
    return problems


def check_flat_namespace(rule, sources):
    type_names = set()
    for path, code in sources.items():
        if path.startswith("Aim/"):
            type_names.update(TYPE_RE.findall(code))
    problems = []
    for path, code in sources.items():
        if not path.startswith("Aim/") or excepted(rule, path) or not DECL_RE.search(code):
            continue
        first_decl = DECL_RE.search(code).start()
        opened = re.search(r"^namespace\s+(\S+)", code, re.M)
        if not opened or opened.start() > first_decl:
            problems.append(f"{path}:{line_of(code, first_decl)}: declarations must be inside `namespace Aim`")
            continue
        name = opened.group(1)
        if name == "Aim":
            continue
        parts = name.split(".")
        if not (len(parts) == 2 and parts[0] == "Aim" and parts[1] in type_names):
            problems.append(f"{path}:{line_of(code, opened.start())}: `namespace {name}` is neither "
                            f"`Aim` nor `Aim.<a type>`")
    return problems


def check_no_root_import(rule, sources):
    return [f"{path}:{line_of(code, m.start())}: imports the root module `Aim`; import the interface file instead"
            for path, code in sources.items() if path.startswith("Aim/")
            for m in re.finditer(r"^import\s+Aim\s*$", code, re.M)]


def check_no_mathlib(rule, sources):
    return [f"{path}:{line_of(code, m.start())}: imports Mathlib"
            for path, code in sources.items() if path.startswith(("Aim/", "tests/")) or path == "Aim.lean"
            for m in re.finditer(r"^import\s+Mathlib\b", code, re.M)]


def check_set_variable_case(rule, sources):
    binders = [
        re.compile(r"[({⦃]\s*([^:(){}\[\]⦃⦄]+?)\s*:\s*" + SET_TYPES),
        re.compile(r"(?:∀|∃|fun|λ)\s+([A-Za-z_][\w' ]*?)\s*:\s*" + SET_TYPES),
    ]
    problems = []
    for path, code in sources.items():
        if excepted(rule, path):
            continue
        seen = set()
        for pattern in binders:
            for match in pattern.finditer(code):
                for name in match.group(1).split():
                    key = (match.start(1), name)
                    if re.fullmatch(r"[a-z_][\w']*", name) and key not in seen:
                        seen.add(key)
                        problems.append(f"{path}:{line_of(code, match.start(1))}: `{name}` is a set "
                                        f"and should be uppercase")
    return problems


CHECKS = {
    "tactic-proofs": check_tactic_proofs,
    "aggregator-naming": check_aggregator_naming,
    "flat-namespace": check_flat_namespace,
    "no-root-import": check_no_root_import,
    "no-mathlib": check_no_mathlib,
    "set-variable-case": check_set_variable_case,
}


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    data = json.loads(SOURCE.read_text(encoding="utf-8"))
    rules = {rule["id"]: rule for rule in data["rules"]}
    problems = []

    enforced = {rid for rid, rule in rules.items() if rule["enforced"]}
    for rid in sorted(enforced - CHECKS.keys()):
        problems.append(f"conventions.json: rule `{rid}` is marked enforced but has no check")
    for rid in sorted(CHECKS.keys() - enforced):
        problems.append(f"check_conventions.py: check `{rid}` has no enforced rule in conventions.json")

    for row in data["deviations"]:
        if not (REPO / row["source"]).is_file():
            problems.append(f"conventions.json: deviation `{row['lean']}` cites missing file {row['source']}")
    for rule in data["rules"]:
        for item in rule["exceptions"]:
            if not (REPO / item["path"]).exists():
                problems.append(f"conventions.json: rule `{rule['id']}` excepts missing path {item['path']}")

    paths = lean_files("Aim", "Aim.lean", "AdventuresInMathematics.lean", "tests", "validation/mathlib")
    sources = {p: strip_comments((REPO / p).read_text(encoding="utf-8")) for p in paths}
    counts = {}
    for rid in sorted(enforced & CHECKS.keys()):
        found = CHECKS[rid](rules[rid], sources)
        counts[rid] = len(found)
        problems.extend(f"[{rid}] {line}" for line in found)

    for line in problems:
        print(line)
    if problems:
        raise SystemExit(f"FAIL: {len(problems)} problem(s) in {len(sources)} files")
    print(f"PASS: {len(sources)} files, {len(counts)} rules checked ({', '.join(sorted(counts))})")


if __name__ == "__main__":
    main()
