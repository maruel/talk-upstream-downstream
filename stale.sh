#!/bin/bash
# Random ideas that I didn't follow through.
set -eu
cd "$(dirname $0)"

# Generate a CSV with iso week directly from git.
# The problem with this method is that it lacks weeks where there were not
# commits and it makes the graph less interesting. Use weekly_commits.py instead
# as shown in gen_all.sh.
cd ./src
echo "ISO Week,Commits/week"
git log --date=format:%G-%V --format=%ad | sort | uniq -c | awk '{print $2 "," $1 }'
cd -

# Generate a graph at the command line with asciigraph. The problem is that this
# tool doesn't support a X axis label, greatly reducing the value proposition.
if ! which asciigraph > /dev/null; then
  go install github.com/guptarohit/asciigraph/cmd/asciigraph@latest
fi
cd ./WebKit
echo "Commit per ISO week - WebKit"
git log --date=format:%G-%V --format=%ad | sort | uniq -c | awk '{print $1}'  | asciigraph -h 43 -w 205
cd -
