#!/bin/bash
echo "------------------------------------------------------------"
echo " Create Parser"
echo "------------------------------------------------------------"
jison src/cssparser.y src/css.l -o lib/cssparser.js
echo ""
echo "------------------------------------------------------------"
echo " Test Parser"
echo "------------------------------------------------------------"
cp ./lib/cssparser.js ./web/
node lib/cli.js test/test.css -c
