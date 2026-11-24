#!/usr/bin/env python3
"""Generate Aim/Common/Notation.tex from Aim/Common/conventions.json.

    python scripts/build_notation.py           write the file
    python scripts/build_notation.py --check   fail if the file is out of date

The JSON file is the single source. Never edit Notation.tex by hand.
"""
import json
import pathlib
import sys

REPO = pathlib.Path(__file__).resolve().parent.parent
SOURCE = REPO / "Aim" / "Common" / "conventions.json"
TARGET = REPO / "Aim" / "Common" / "Notation.tex"

# Lean's Unicode symbols, as TeX. A symbol missing from this table is an
# error, so that nothing reaches the page unrendered.
UNICODE = {
    "∈": r"$\in$", "∉": r"$\notin$", "⊆": r"$\subseteq$", "∅": r"$\varnothing$",
    "∪": r"$\cup$", "∩": r"$\cap$", "≤": r"$\le$", "≥": r"$\ge$", "≠": r"$\ne$",
    "⁻¹": r"$^{-1}$", "ε": r"$\varepsilon$", "→": r"$\to$", "∀": r"$\forall$",
    "∃": r"$\exists$", "↔": r"$\leftrightarrow$", "∧": r"$\land$", "∨": r"$\lor$",
    "¬": r"$\lnot$", "∘": r"$\circ$", "⋃₀": r"$\bigcup_0$", "⋂₀": r"$\bigcap_0$",
    "⋃": r"$\bigcup$", "⋂": r"$\bigcap$", "ᶜ": r"$^{c}$", "∣": r"$\mid$",
    "⊔": r"$\sqcup$", "⊓": r"$\sqcap$", "⨆": r"$\bigsqcup$", "⨅": r"{\large$\sqcap$}",
    "⊥": r"$\bot$", "⊤": r"$\top$", "α": r"$\alpha$", "β": r"$\beta$", "…": r"\dots{}",
}
SPECIAL = {
    "\\": r"\textbackslash{}", "{": r"\{", "}": r"\}", "_": r"\_", "&": r"\&",
    "%": r"\%", "#": r"\#", "$": r"\$", "^": r"\^{}", "~": r"\~{}",
    "<": r"\textless{}", ">": r"\textgreater{}", "|": r"\textbar{}",
}


def escape(text):
    """Escape plain text for TeX, translating Lean's Unicode symbols."""
    out = []
    i = 0
    while i < len(text):
        for symbol, tex in UNICODE.items():
            if text.startswith(symbol, i):
                out.append(tex)
                i += len(symbol)
                break
        else:
            char = text[i]
            if char in SPECIAL:
                out.append(SPECIAL[char])
            elif ord(char) < 128:
                out.append(char)
            else:
                raise SystemExit(f"build_notation: no TeX for {char!r} in {text!r}; add it to UNICODE")
            i += 1
    return "".join(out)


def prose(text):
    """Escape prose, setting `backquoted` spans in typewriter type."""
    parts = text.split("`")
    out = []
    for index, part in enumerate(parts):
        out.append(r"\texttt{" + escape(part) + "}" if index % 2 else escape(part))
    return "".join(out)


def table(columns, header, rows):
    """A three-column longtable. `columns` are the widths as fractions of the line."""
    spec = "".join(r">{\raggedright" + (r"\arraybackslash" if i == len(columns) - 1 else "")
                   + "}p{" + f"{width:.2f}" + r"\linewidth}" for i, width in enumerate(columns))
    lines = [r"\begin{longtable}{@{}" + spec + "@{}}", r"\toprule",
             " & ".join(header) + r" \\", r"\midrule", r"\endhead"]
    lines += [" & ".join(row) + r" \\" for row in rows]
    return lines + [r"\bottomrule", r"\end{longtable}", ""]


def render_naming(naming):
    lines = [r"\section*{Naming}", r"\noindent " + prose(naming["about"]), "",
             r"\subsection*{References}", r"\begin{itemize}"]
    for ref in naming["references"]:
        lines.append(r"\item " + escape(ref["title"]) + r": \url{" + ref["url"] + "}. Covers "
                     + prose(ref["covers"]) + ".")
    lines += [r"\end{itemize}", "", r"\subsection*{Capitalisation}"]
    lines += table([0.46, 0.18, 0.30], ["What is named", "Written in", "Example"],
                   [[prose(row["kind"]), escape(row["case"]), r"\texttt{" + escape(row["example"]) + "}"]
                    for row in naming["capitalisation"]])

    lines += [r"\subsection*{Names of symbols}",
              r"\noindent A theorem name is its statement read aloud with these words."]
    group = None
    rows = []
    for row in naming["symbols"]:
        if row["group"] != group:
            group = row["group"]
            rows.append([r"\emph{" + escape(group) + "}", "", ""])
        rows.append([r"\texttt{" + escape(row["symbol"]) + "}", r"\texttt{" + escape(row["name"]) + "}",
                     prose(row["note"])])
    lines += table([0.18, 0.22, 0.54], ["Symbol", "Name", "Note"], rows)

    lines += [r"\subsection*{Patterns in names}"]
    lines += table([0.20, 0.46, 0.28], ["Pattern", "Meaning", "Example"],
                   [[r"\texttt{" + escape(row["pattern"]) + "}", prose(row["meaning"]), prose(row["example"])]
                    for row in naming["patterns"]])

    lines += [r"\subsection*{Where this project differs}"]
    for row in naming["local"]:
        lines += [r"\paragraph{" + prose(row["topic"]) + "}",
                  "Lean: " + prose(row["lean"]) + ". Here: " + prose(row["here"]) + ". Reason: "
                  + prose(row["why"]) + ".", ""]
    return lines


def render(data):
    lines = [
        "% GENERATED from Aim/Common/conventions.json by scripts/build_notation.py.",
        "% Do not edit this file. Edit the JSON and run the script.",
        r"\documentclass[11pt]{article}",
        r"\usepackage[margin=1in]{geometry}",
        r"\usepackage[T1]{fontenc}",
        r"\usepackage{lmodern}",
        r"\usepackage{amsmath,amssymb}",
        r"\usepackage{booktabs,longtable,array}",
        r"\usepackage{url}",
        r"\renewcommand{\arraystretch}{1.25}",
        r"\title{" + escape(data["title"]) + "}",
        r"\author{Adventures in Mathematics}",
        r"\date{}",
        r"\begin{document}",
        r"\maketitle",
        "",
        r"\noindent This page lists how letters are used in the Lean sources, where the",
        r"Lean departs from standard notation, and the conventions the sources follow.",
        r"It is generated from",
        r"\texttt{Aim/Common/conventions.json}.",
        "",
        r"\section*{Letters}",
        r"\begin{longtable}{@{}>{\raggedright}p{0.20\linewidth}>{\raggedright}p{0.34\linewidth}>{\raggedright\arraybackslash}p{0.38\linewidth}@{}}",
        r"\toprule",
        r"Letters & Stand for & Note \\",
        r"\midrule",
        r"\endhead",
    ]
    for row in data["variables"]:
        lines.append(f"{escape(row['letters'])} & {prose(row['stands_for'])} & {prose(row['note'])} \\\\")
    lines += [r"\bottomrule", r"\end{longtable}", ""]

    lines += [
        r"\section*{Where the Lean differs from standard notation}",
        r"\noindent Standard mathematical notation is used wherever Lean has it and is",
        r"not listed here. These are the exceptions.",
        r"\begin{longtable}{@{}>{\raggedright}p{0.26\linewidth}>{\raggedright}p{0.24\linewidth}>{\raggedright\arraybackslash}p{0.42\linewidth}@{}}",
        r"\toprule",
        r"Standard & In Lean & Why \\",
        r"\midrule",
        r"\endhead",
    ]
    for row in data["deviations"]:
        lean = r"\texttt{" + escape(row["lean"]) + "}"
        lines.append(f"${row['standard']}$ & {lean} & {prose(row['why'])} \\\\")
    lines += [r"\bottomrule", r"\end{longtable}", ""]

    lines += [
        r"\section*{Names}",
        r"\noindent A concept whose Lean name is abbreviated also has a readable full",
        r"name. The Lean name is the definition; the full name stands for it.",
        r"\begin{longtable}{@{}>{\raggedright}p{0.20\linewidth}>{\raggedright}p{0.32\linewidth}>{\raggedright\arraybackslash}p{0.40\linewidth}@{}}",
        r"\toprule",
        r"Lean name & Readable name & Meaning \\",
        r"\midrule",
        r"\endhead",
    ]
    for row in data["names"]:
        lean = r"\texttt{" + escape(row["lean"]) + "}"
        readable = r"\texttt{" + escape(row["readable"]) + "}"
        lines.append(f"{lean} & {readable} & {prose(row['meaning'])} \\\\")
    lines += [r"\bottomrule", r"\end{longtable}", ""]

    lines += render_naming(data["naming"])

    lines += [r"\section*{Conventions}", r"\begin{enumerate}"]
    for rule in data["rules"]:
        mark = "checked automatically" if rule["enforced"] else "not checked automatically"
        lines.append(r"\item " + prose(rule["statement"]) + r" \emph{(" + mark + ")}")
        if rule["exceptions"]:
            lines.append(r"\begin{itemize}")
            for item in rule["exceptions"]:
                lines.append(r"\item Exception: \texttt{" + escape(item["path"]) + "}, " + prose(item["reason"]) + ".")
            lines.append(r"\end{itemize}")
    lines += [r"\end{enumerate}", r"\end{document}", ""]
    return "\n".join(lines)


def main():
    data = json.loads(SOURCE.read_text(encoding="utf-8"))
    text = render(data)
    if "--check" in sys.argv:
        current = TARGET.read_text(encoding="utf-8").replace("\r\n", "\n") if TARGET.exists() else ""
        if current != text:
            raise SystemExit("Aim/Common/Notation.tex is out of date: run python scripts/build_notation.py")
        print("Notation.tex is up to date")
        return
    TARGET.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {TARGET.relative_to(REPO)}")


if __name__ == "__main__":
    main()
