@echo off
cd ..
@echo on
echo Installing dependencies
haxelib install lime
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
echo User input Required
haxelib run flixel-tools setup
haxelib install polymod
haxelib git thx.core https://github.com/fponticelli/thx.core
haxelib git thx.semver https://github.com/fponticelli/thx.semver
haxelib git faxe https://github.com/uhrobots/faxe
haxelib git extension-webm https://github.com/KadeDev/extension-webm
lime rebuild extension-webm windows
haxelib install hxdiscord_rpc
echo Finished!
pause