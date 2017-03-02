#!/bin/bash
echo "------------------------------------------------------------"
echo " Create Parser"
echo "------------------------------------------------------------"
gulp merge
jison dist/cssparser.y dist/css.l -o lib/cssparser.js
cp ./lib/cssparser.js ./web/
echo ""
echo "------------------------------------------------------------"
echo " Test Parser"
echo "------------------------------------------------------------"
node lib/cli.js test/test.css -c
