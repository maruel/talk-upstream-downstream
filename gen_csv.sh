#!/bin/bash
set -eu
git log --date=short --format=%ad | "$(dirname $0)"/weekly_commits.py > $1
