@echo off
haxelib run munit test
echo.
echo.
haxelib run checkstyle -s fruiton
echo.
echo Java build no compile started
haxe build-java.hxml
echo Java build no compile finished