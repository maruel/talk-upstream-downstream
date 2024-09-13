#!/bin/bash
set -eu
cd "$(dirname $0)"
ROOT="$(pwd)"
DATA=$ROOT/data

## Chromium

echo "src.git"
cd ./src
# Get logs with accounts to filter robot accounts.
git log --date=short --format='%ad %ae' > ${DATA}/src_raw.txt
cat ${DATA}/src_raw.txt | cut -f 1 -d ' ' > ${DATA}/src.txt
cat ${DATA}/src_raw.txt | grep -v 'gserviceaccount\.com$' | grep -v '^mdb\.' | cut -f 1 -d ' ' > ${DATA}/src_humans.txt
cat ${DATA}/src.txt | ${ROOT}/weekly_commits.py > ${DATA}/src.csv
cat ${DATA}/src_humans.txt | ${ROOT}/weekly_commits.py > ${DATA}/src_humans.csv
${ROOT}/compare_rates.py ${DATA}/src.txt ${DATA}/src_humans.txt > ${DATA}/comparison_src.csv
cd -

## WebKit - Blink

echo "src.git -- third_party/blink"
cd ./src
git log --date=short --format=%ad -- third_party/blink > ${DATA}/src_blink.txt
cat ${DATA}/src_blink.txt | ${ROOT}/weekly_commits.py > ${DATA}/src_blink.csv
cd -

echo "WebKit.git"
cd ./WebKit
git log --date=short --format='%ad %ae' > ${DATA}/WebKit_raw.txt
cat ${DATA}/WebKit_raw.txt | cut -f 1 -d ' ' > ${DATA}/WebKit.txt
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
git log --date=short --format='%ad %ae' > ${DATA}/linux_raw.txt
cat ${DATA}/linux_raw.txt | cut -f 1 -d ' ' > ${DATA}/linux.txt
cat ${DATA}/linux.txt | ${ROOT}/weekly_commits.py > ${DATA}/linux.csv
git log --date=short --format=%ad --merges > ${DATA}/linux_merges_only.txt
cat ${DATA}/linux_merges_only.txt | ${ROOT}/weekly_commits.py > ${DATA}/linux_merges_only.csv
${ROOT}/compare_rates.py ${DATA}/linux.txt ${DATA}/linux_merges_only.txt > ${DATA}/comparison_linux.csv
cd -
