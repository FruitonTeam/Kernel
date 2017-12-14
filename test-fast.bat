@echo off
haxelib run munit test
echo.
echo.
haxelib run checkstyle -s fruiton
echo.
haxe build-java.hxml