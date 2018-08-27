#! /bin/bash

for file in tests/output/*tex; do

   target=$(basename "$file")

   echo "> " ${target}
   diff tests/expected/${target} tests/output/${target}

done
