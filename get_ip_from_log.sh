#!/bin/bash
cat auth.log | grep Failed | \
grep -o '\s\+\([1-2]\{0,1\}[0-9]\{0,1\}[0-9]\.\)\{3\}\([1-2]\{0,1\}[0-9]\{0,1\}[0-9]\)' | \
cut -d ' ' -f 2 | sort | uniq | more
