#!/bin/bash

# This script embeds pom.xml with basic info from pom.properties into created .jar file by haxe.
# pom.xml must be included so Artifactory can correctly resolve .jar properties

DIR=$(pwd)
JAR_NAME=kernel

. pom.properties

echo "Cleaning up build directory..."
rm -rf build

echo "Compiling..."
haxe fruiton.kernel.Kernel -cp src -java build/${JAR_NAME}

tmpdir=$(mktemp -d /tmp/kernel_maven.XXXXXXXXXX) # template is provided because it is mandatory option on macOS

cp build/${JAR_NAME}/${JAR_NAME}.jar ${tmpdir}

cd ${tmpdir}

echo "Extracting jar..."

jar xvf ${JAR_NAME}.jar > /dev/null
rm ${JAR_NAME}.jar

mkdir -p META-INF/maven/${groupId}/${artifactId}

echo "Embedding pom.xml..."

cat > META-INF/maven/${groupId}/${artifactId}/pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>${groupId}</groupId>
    <artifactId>${artifactId}</artifactId>
    <version>${version}</version>
</project>
EOF

echo "Creating jar..."

jar cvf ${JAR_NAME}.jar * > /dev/null

# remove the original .jar so cp won't ask for overwrite approval
rm ${DIR}/build/${JAR_NAME}/${JAR_NAME}.jar
cp kernel.jar ${DIR}/build/${JAR_NAME}

echo "Finished: "${DIR}/build/${JAR_NAME}/${JAR_NAME}.jar