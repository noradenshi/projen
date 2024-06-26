#!/bin/bash
set -e

# About:
# Generates a Java ant project

# Structure:
#
# $name
#   /build (not directly)
#   /lib
#   /src
#       /$package
#           Main.java
#   build.xml 

read -p "Package name: " package;
read -p "MainClass name: " mainclass;

mkdir $name
cd $name

mkdir lib -p src/$package

cat << EOF > ./src/$package/${mainclass}.java
package $package;

public class $mainclass {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
EOF

cat > ./build.xml << EOF
<project name="${name}" basedir="." default="main">

    <property name="main-class" value="${package}.${mainclass}"/>

    <property name="src.dir" value="src"/>
    <property name="lib.dir" value="lib"/>
    <property name="build.dir" value="build"/>
    <property name="classes.dir" value="\${build.dir}/classes/"/>
    <property name="jar.dir" value="\${build.dir}/jar/"/>

    <path id="classpath">
        <fileset dir="\${lib.dir}" includes="**/*.jar"/>
    </path>

    <target name="clean">
        <delete dir="\${build.dir}"/>
    </target>

    <target name="compile">
        <mkdir dir="\${classes.dir}"/>
        <javac srcdir="\${src.dir}" destdir="\${classes.dir}" classpathref="classpath"/>
        <copy todir="\${classes.dir}">
            <fileset dir="\${src.dir}" excludes="**/*.java"/>
        </copy>
    </target>

    <target name="jar" depends="compile">
        <mkdir dir="\${jar.dir}"/>
        <jar destfile="\${jar.dir}/\${ant.project.name}.jar" basedir="\${classes.dir}">
            <manifest>
                <attribute name="Main-Class" value="\${main-class}"/>
            </manifest>
        </jar>
    </target>

    <target name="run" depends="jar">
        <java fork="true" classname="\${main-class}">
            <classpath>
                <path refid="classpath"/>
                <path location="\${jar.dir}/\${ant.project.name}.jar"/>
            </classpath>
        </java>
    </target>

    <target name="clean-build" depends="clean,jar"/>

    <target name="main" depends="clean,run"/>

</project>
EOF
