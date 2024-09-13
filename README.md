# Notes

This repository contains the code to generate the graphs shown in my talk at
ForwardJS Ottawa on 2024-09-19.

Check out with:

```
git clone --recurse-submodules https://github.com/maruel/talk-upstream-downstream
cd talk-upstream-downstream
git config bash.showDirtyState false
git submodule foreach --recursive git config bash.showDirtyState false
./gen_all.sh
```

This may take an hour.
