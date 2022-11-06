#!/usr/bin/env bash

## Usage: $ . ./setenv.sh

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ] ; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

getOS() {
    local os
    case "$(uname -s)" in
        Linux*)  os=linux;;
        Darwin*) os=mac;;
        CYGWIN*) os=cygwin;;
        MINGW*)  os=mingw;;
        *)       os=unknown
    esac
    echo $os
}

getPath() {
    local path=""
    for i in $(ls -d "$1"*/ 2>/dev/null); do path=$i; done
    # ignore trailing slash introduced in for loop
    [[ -z "$path" ]] && echo "" || echo "${path::-1}"
}

##############################################################################
## Environment setup

PROG_HOME="$(getHome)"

OS="$(getOS)"
[[ $OS == "unknown" ]] && { echo "Unsuppored OS"; exit 1; }

if [[ $OS == "cygwin" || $OS == "mingw" ]]; then
    [[ $OS == "cygwin" ]] && prefix="/cygdrive" || prefix=""
    export HOME=$prefix/c/Users/$USER
    export ANT_HOME="$(getPath "$prefix/c/opt/apache-ant-1")"
    export BAZEL_HOME="$(getPath "$prefix/c/opt/bazel-5")"
    export CFR_HOME="$(getPath "$prefix/c/opt/cfr-0.15")"
    export JAVA_HOME="$(getPath "$prefix/c/opt/jdk-temurin-11")"
    export GRADLE_HOME="$(getPath "$prefix/c/opt/gradle-7")"
    export GIT_HOME="$(getPath "$prefix/c/opt/Git-2")"
    export KOTLIN_HOME="$(getPath "$prefix/c/opt/kotlinc-1.7")"
    export MAVEN_HOME="$(getPath "$prefix/c/opt/apache-maven-3")"
    export MILL_HOME="$(getPath "$prefix/c/opt/mill-0.10")"
    export SBT_HOME="$(getPath "$prefix/c/opt/sbt-1.7")"
    export SCALA_HOME="$(getPath "$prefix/c/opt/scala-2.13")"
    export SCALA3_HOME="$(getPath "$prefix/c/opt/scala3-3")"
else
    export ANT_HOME="$(getPath "/opt/apache-ant-1")"
    export BAZEL_HOME="$(getPath "/opt/bazel-5")"
    export GIT_HOME="$(getPath "/opt/git-2")"
    export GRADLE_HOME="$(getPath "/opt/gradle-7")"
    export JAVA_HOME="$(getPath "/opt/jdk-temurin-11")"
    export KOTLIN_HOME="$(getPath "/opt/kotlinc")"
    export MAVEN_HOME="$(getPath "/opt/apache-maven-3")"
    export MILL_HOME="$(getPath "/opt/mill-0.10")"
    export SBT_HOME="$(getPath "/opt/sbt-1.7")"
    export SCALA_HOME="$(getPath "/opt/scala-2.13")"
    export SCALA3_HOME="$(getPath "/opt/scala3-3")"
fi
PATH1="$PATH"
[[ -x "$ANT_HOME/bin/ant" ]] && PATH1="$PATH1:$ANT_HOME/bin"
[[ -x "$BAZEL_HOME/bazel" ]] && PATH1="$PATH1:$BAZEL_HOME"
[[ -x "$GRADLE_HOME/bin/gradle" ]] && PATH1="$PATH1:$GRADLE_HOME/bin"
[[ -x "$MAVEN_HOME/bin/mvn" ]] && PATH1="$PATH1:$MAVEN_HOME/bin"
[[ -x "$MILL_HOME/mill" ]] && PATH1="$PATH1:$MILL_HOME"
[[ -x "$SBT_HOME/bin/sbt" ]] && PATH1="$PATH1:$SBT_HOME"
[[ -x "$GIT_HOME/bin/git" ]] && PATH1="$PATH1:$GIT_HOME/bin"
export PATH="$PATH1"
