#!/usr/bin/env bash
set -euo pipefail

# 100 MiB. Use 100000000 instead if you need decimal 100 MB.
limit=$((100 * 1024 * 1024))

oids=()
paths=()
oldpaths=()
statuses=()

# Read staged Added, Copied, Modified, and Renamed files only.
# Uses --raw so we get the staged blob object ID directly.
while IFS= read -r -d '' meta; do
  read -r _oldmode _newmode _oldsha newsha status <<<"${meta#:}"

  oldpath=""

  if [[ "$status" == R* || "$status" == C* ]]; then
    IFS= read -r -d '' oldpath
    IFS= read -r -d '' path
  else
    IFS= read -r -d '' path
  fi

  oids+=("$newsha")
  paths+=("$path")
  oldpaths+=("$oldpath")
  statuses+=("$status")
done < <(git diff --cached --raw -z --diff-filter=ACMR)

# Nothing staged that matches ACMR.
if ((${#oids[@]} == 0)); then
  exit 0
fi

to_unstage=()
i=0

# Batch-check all staged blob sizes in one Git process.
while IFS= read -r -d '' size; do
  path="${paths[$i]}"
  oldpath="${oldpaths[$i]}"
  status="${statuses[$i]}"

  if [[ "$size" =~ ^[0-9]+$ && "$size" -gt "$limit" ]]; then
    printf 'Unstaging "%s" (%s bytes)\n' "$path" "$size"

    # For staged renames, unstage both sides so the staged rename is fully removed.
    if [[ "$status" == R* && -n "$oldpath" ]]; then
      to_unstage+=("$oldpath")
    fi

    to_unstage+=("$path")
  fi

  ((++i))
done < <(
  printf '%s\0' "${oids[@]}" |
    git cat-file --batch-check='%(objectsize)' -Z --buffer
)

# Unstage only files whose staged blob size exceeded the limit.
if ((${#to_unstage[@]} > 0)); then
  printf '%s\0' "${to_unstage[@]}" |
    git restore --staged --pathspec-from-file=- --pathspec-file-nul
fi