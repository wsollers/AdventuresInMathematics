#!/usr/bin/env bash

set -euo pipefail

# Build output/pdf/numbers_syntax_and_wiring.pdf from its TeX source.
# Set TECTONIC=/path/to/tectonic to select a compiler explicitly.

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

tex_source="$repo_root/output/pdf/numbers_syntax_and_wiring.tex"
output_dir="$repo_root/output/pdf"

tectonic_version="0.17.0"
tectonic_archive="tectonic-$tectonic_version-x86_64-unknown-linux-gnu.tar.gz"
tectonic_url="https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.17.0/$tectonic_archive"
tectonic_sha256="1a715688baf591e650c8aeb160ae934e181685eecbb38b317de30b269ac5d606"

if [[ ! -f "$tex_source" ]]; then
  echo "TeX source not found: $tex_source" >&2
  exit 1
fi

if [[ -n "${TECTONIC:-}" ]]; then
  tectonic_bin="$TECTONIC"
elif command -v tectonic >/dev/null 2>&1; then
  tectonic_bin="$(command -v tectonic)"
else
  if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
    echo "Tectonic is not installed and the automatic fallback supports only Linux x86_64." >&2
    echo "Install Tectonic or set TECTONIC to its executable path." >&2
    exit 1
  fi

  tool_dir="$repo_root/tmp/tectonic/$tectonic_version"
  tectonic_bin="$tool_dir/tectonic"

  if [[ ! -x "$tectonic_bin" ]]; then
    archive_path="$tool_dir/$tectonic_archive"
    mkdir -p "$tool_dir"

    echo "Downloading Tectonic $tectonic_version..."
    curl --proto '=https' --tlsv1.2 --fail --location --silent --show-error \
      "$tectonic_url" --output "$archive_path"

    echo "$tectonic_sha256  $archive_path" | sha256sum --check --status
    tar -xzf "$archive_path" -C "$tool_dir"
    rm "$archive_path"
  fi
fi

if [[ ! -x "$tectonic_bin" ]]; then
  echo "Tectonic executable is not runnable: $tectonic_bin" >&2
  exit 1
fi

mkdir -p "$output_dir"

# Prevent the PDF metadata timestamp from changing an otherwise identical build.
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-0}"
"$tectonic_bin" --outdir "$output_dir" "$tex_source"

pdf_output="$output_dir/numbers_syntax_and_wiring.pdf"
if [[ ! -s "$pdf_output" ]]; then
  echo "PDF build failed to produce a nonempty file: $pdf_output" >&2
  exit 1
fi

echo "Built $pdf_output"
