#!/usr/bin/env python3
"""Takes weekly_commits.py input and creates multiple aligned columns."""
from collections import Counter
from datetime import date, timedelta
import os
import sys
dailies = [[date.fromisoformat(l.strip()) for l in open(n) if l.strip()] for n in sys.argv[1:]]
counts = [dict(Counter(d.isocalendar()[:2] for d in k)) for k in dailies]
top = max(max(v) for v in dailies)
cur = min(min(v) for v in dailies)
print("ISO Week," + ",".join(os.path.basename(l.split(".")[0]) for l in sys.argv[1:]))
while cur <= top:
  key = cur.isocalendar()[:2]
  print(f"{key[0]}-{key[1]:02d}," + ",".join(str(n.get(key, 0)) for n in counts))
  cur += timedelta(weeks=1)
