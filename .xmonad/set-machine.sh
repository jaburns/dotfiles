#/bin/bash

# data Machine = Desktop | Laptop

rm -f xmonad.hs
echo "import XMonadConfig" > xmonad.hs
echo "main = mainAction $1" >> xmonad.hs
echo ""
echo "Updated xmonad.hs..."
echo ""
cat xmonad.hs
echo ""
