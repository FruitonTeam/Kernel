$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';

haxe build-compile.hxml;

$DIR = (pwd).path;

if (Test-Path kernel_build_tmp_dir) {
    Remove-Item -Force -Recurse kernel_build_tmp_dir;
}
mkdir kernel_build_tmp_dir;

cp build/java/java.jar kernel_build_tmp_dir;

cd kernel_build_tmp_dir;

jar xvf java.jar;

cp -r "$($DIR)/resources" resources;

rm "$($DIR)/build/java/java.jar";
jar cvf "$($DIR)/build/java/java.jar" *;

cd ..;
Remove-Item -Force -Recurse kernel_build_tmp_dir;
