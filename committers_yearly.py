#!/usr/bin/env python3
"""Takes "git log --date=format:%Y --format'=%ad %ae'" as input."""
from collections import Counter
from datetime import date, timedelta
import sys
WELL_KNOWN_DOMAINS = ('emc.com', 'endruntechnologies.com', 'gmail.com', 'ibm.com', 'intel.com', 'linutronix.de', 'mail.ru', 'redhat.com', 'samsung.com')
def get_domain(e):
  """Returns the domain from the git commit author email address.

  This function primarily deals with linux.git inconsistent addresses.
  """
  # From linux.git, what remains is:
  # - (address.hidden)
  # - ?
  # - ainan.at
  # - hch
  # - lopez
  # - mark.langsdorf
  # - nayak
  # - pablo.neira.ayuso
  # - stephenm.cameron
  e = e.lower().replace(' ! ', '.').replace(' ', '.').replace('redhatcom', 'redhat.com')
  for a in ('.at.', '_at_', '-at-', '.().', 'œ'):
    if a in e:
      e = e.replace(a, '@')
      break
  if '@' in e:
    return e.rsplit('@', 1)[1]
  if e.startswith('at.'):
    return e[3:]
  for s in WELL_KNOWN_DOMAINS:
    if e.endswith(s):
      return s
  return 'unknown'

def process(e):
  """From a raw email address, returns the cleaned domain.

  Primarily deal with src.git/blink.git/WebKit.git.
  """
  d = get_domain(e).strip('.')
  if d.endswith('gserviceaccount.com'):
    return 'gserviceaccount.com'
  if d.endswith('.corp-partner.google.com'):
    return d.replace('.corp-partner.google.com', '.com')
  if d == 'prod.google.com':
    return 'google.com'
  if d == 'googlemail.com':
    return 'gmail.com'
  for s in WELL_KNOWN_DOMAINS:
    if e.endswith(s):
      return s
  # src.git's merge of webkit. This is not strictly correct, it's very
  # disappointing to have lost ownership there.
  if d == 'bbb929c8-8fbe-4397-9dbb-9b2b20218538':
    return 'apple.com'
  if d == '0039d316-1c4b-4281-b951-d872f2087c98':
    return 'google.com'
  return d

# Necessary because of bad commit dates in linux.git.
now = date.today().year
daily = [(max(min(date.fromisoformat(n[0]).year, now), 2001), process(n[1])) for n in (l.strip().split(' ', 1) for l in sys.stdin if ' ' in l.strip())]
counts = Counter(daily)

def print_all():
  print("ISO Week,Commits/week")
  for (year, domain), count in sorted(counts.items()):
    print(f'{year},{domain},{count}')

def print_top():
  # TODO: others
  top = []
  for _, d in sorted(((v, k[1]) for k, v in counts.items()), reverse=True):
    if d in top:
      continue
    top.append(d)
    if len(top) == 20:
      break
  print("Year," + ",".join(top))
  cur = max(min(d[0] for d in daily), 2001)
  while cur <= now:
    print(f'{cur},{",".join(str(counts.get((cur, t), 0)) for t in top)}')
    cur += 1

#print_all()
print_top()

