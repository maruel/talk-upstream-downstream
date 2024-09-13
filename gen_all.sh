#!/bin/bash
set -eu
cd "$(dirname $0)"
ROOT="$(pwd)"
DATA=$ROOT/data

## Chromium

echo "src.git"
cd ./src
git log --date=short --format=%ad > ${DATA}/src.txt
cat ${DATA}/src.txt | ${ROOT}/weekly_commits.py > ${DATA}/src.csv
cd -

echo "src.git no-roll"
cd ./src
git log --date=short --format=%ad --grep '^Roll' --invert-grep > ${DATA}/src_no_roll.txt
cat ${DATA}/src_no_roll.txt | ${ROOT}/weekly_commits.py > ${DATA}/src_no_roll.csv
cd -

echo "src comparison"
${ROOT}/compare_rates.py ${DATA}/src.txt ${DATA}/src_no_roll.txt > ${DATA}/comparison_src.csv

## WebKit - Blink

echo "src.git -- third_party/blink"
cd ./src
git log --date=short --format=%ad -- third_party/blink > ${DATA}/src_blink.txt
cat ${DATA}/src_blink.txt | ${ROOT}/weekly_commits.py > ${DATA}/src_blink.csv
cd -

echo "WebKit.git"
cd ./WebKit
git log --date=short --format=%ad > ${DATA}/WebKit.txt
cat ${DATA}/WebKit.txt | ${ROOT}/weekly_commits.py > ${DATA}/WebKit.csv
cd -

echo "blink.git"
cd ./blink
git log --date=short --format=%ad > ${DATA}/blink.txt
cat ${DATA}/blink.txt | ${ROOT}/weekly_commits.py > ${DATA}/blink.csv
cd -

echo "blink combined"
cat ${DATA}/blink.txt > ${DATA}/blink_combined.txt
cat ${DATA}/src_blink.txt >> ${DATA}/blink_combined.txt
cat ${DATA}/blink_combined.txt | ${ROOT}/weekly_commits.py > ${DATA}/blink_combined.csv

echo "blink - WebKit comparison"
${ROOT}/compare_rates.py ${DATA}/blink_combined.txt ${DATA}/WebKit.txt > ${DATA}/comparison_webkit_blink.csv

## Linux

echo "linux.git"
cd ./linux
git log --date=short --format=%ad > ${DATA}/linux.txt
cat ${DATA}/linux.txt | ${ROOT}/weekly_commits.py > ${DATA}/linux.csv
cd -

echo "linux.git merges only"
cd ./linux
git log --date=short --format=%ad --merges > ${DATA}/linux_merges_only.txt
cat ${DATA}/linux_merges_only.txt | ${ROOT}/weekly_commits.py > ${DATA}/linux_merges_only.csv
cd -

echo "linux comparison"
${ROOT}/compare_rates.py ${DATA}/linux.txt ${DATA}/linux_merges_only.txt > ${DATA}/comparison_linux.csv
