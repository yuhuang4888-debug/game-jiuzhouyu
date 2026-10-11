@echo off
echo.
echo es6×ªes5ÖÐ...
cd ../cdn && babel js/bundle.js -o js/bundle_es5.js && babel js/subPackage.js -o js/subPackage_es5.js
echo end