#! /bin/bash
set -e

powdr pil -o build -f src/ml_zkvm.asm -i 1,0,0,1 --export-csv --field gl
csvtool -u TAB namedcol Row,A0,A1,B0,B1,C0,C1,D0,D1 build/columns.csv | head -n 30