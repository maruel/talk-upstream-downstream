#!/usr/bin/env python3
"""Takes 'git log --date=short --format=%ad' as input."""
from collections import Counter
from datetime import date, timedelta
import sys
daily = [date.fromisoformat(l.strip()) for l in sys.stdin]
counts = Counter(d.isocalendar()[:2] for d in daily)
top = max(daily)
cur = min(daily)
print("ISO Week,Commits/week")
while cur <= top:
  key = cur.isocalendar()[:2]
  print(f"{key[0]}-{key[1]:02d},{counts.get(key, 0)}")
  cur += timedelta(weeks=1)
