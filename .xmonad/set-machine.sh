#/bin/bash

rm -f xmonad.hs
echo "import XMonadConfig" > xmonad.hs
echo "main = mainAction $1" >> xmonad.hs
echo ""
echo "Updated xmonad.hs..."
echo ""
cat xmonad.hs
echo ""
