#!/usr/bin/env bash
#
# Copyright (c) 2018-2020 Stéphane Micheloud
#
# Licensed under the MIT License.
#

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

# use variables DEBUG, EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    if [[ $TIMER -eq 1 ]]; then
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total elapsed time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL EXITCODE=$EXITCODE" 1>&2
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=1 && return $EXITCODE

    for arg in "$@"; do
        case "$arg" in
        ## options
        -debug)       DEBUG=1 ;;
        -help)        HELP=1 ;;
        -timer)       TIMER=1 ;;
        -*)
            echo "$ERROR_LABEL Unknown option $arg" 1>&2
            EXITCODE=1 && return $EXITCODE
            ;;
        ## subcommands
        arch)         CLONE=1 & COMPILE=1 & BOOTSTRAPPED=1 & ARCHIVES=1 ;;
        archives)     CLONE=1 & COMPILE=1 & BOOTSTRAPPED=1 & ARCHIVES=1 ;;
        boot)         CLONE=1 & COMPILE=1 & BOOTSTRAPPED=1 ;;
        bootstrap)    CLONE=1 & COMPILE=1 & BOOTSTRAPPED=1 ;;
        clean)        CLEAN=1 ;;
        clone)        CLONE=1 ;;
        community)    COMMUNITY_BUILD=1 ;;
        compile)      COMPILE=1 ;;
        doc)          COMPILE=1 & BOOTSTRAPPED=1 & COMMUNITY_BUILD=1 & DOCUMENTATION=1 ;;
        documenation) COMPILE=1 & BOOTSTRAPPED=1 & COMMUNITY_BUILD=1 & DOCUMENTATION=1 ;;
        help)         HELP=1 ;;
        java11)       CLONE=1 & JAVA11=1 ;;
        *)
            echo "$ERROR_LABEL Unknown subcommand $arg" 1>&2
            EXITCODE=1 && return $EXITCODE
            ;;
        esac
    done
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL BOOTSTRAPPED=$BOOTSTRAPPED CLEAN=$CLEAN CLONE=$CLONE COMPILE=$COMPILE HELP=$HELP TIMER=$TIMER" 1>&2
    # See http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
    [[ $TIMER -eq 1 ]] && TIMER_START=$(date +"%s")
    return $EXITCODE
}

help() {
cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -debug           show commands executed by this script
    -timer           display total elapsed time

  Subcommands:
    arch[ives]       generate gz/zip archives (after bootstrap)
    boot[strap]      generate+test bootstrapped compiler (after compile)
    clean            delete generated files
    clone            update submodules
    compile          generate+test 1st stage compiler (after clone)
    community        test community-build
    doc[umentation]  generate documentation (after bootstrap)
    help             display this help message
    java11           generate+test Dotty compiler with Java 11
    sbt              test sbt-dotty (after bootstrap)
EOS
}

clone() {
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $GIT_CMD submodule sync" 1>&2
    $GIT_CMD submodule sync
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $GIT_CMD submodule update --init --recursive --jobs 7" 1>&2
    $GIT_CMD submodule update --init --recursive --jobs 7
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

clean() {
    echo "${COLOR_START}run sbt clean and git clean -xdf${COLOR_END}"

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt clean" 1>&2
    $SCRIPTS_DIR/sbt clean
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $GIT_CMD clean -xdf --exclude=*.bat --exclude=*.ps1" 1>&2
    $GIT_CMD clean -xdf --exclude=*.bat --exclude=*.ps1 --exclude=build.sh
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

test_compiled() {
    echo "${COLOR_START}sbt compile and sbt test${COLOR_END}"

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt \";compile ;test\"" 1>&2
    $SCRIPTS_DIR/sbt ";compile ;test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/cmdTests" 1>&2
    $SCRIPTS_DIR/cmdTests
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

test_bootstrapped() {
    echo "${COLOR_START}sbt dotty-bootstrapped/compile and sbt dotty-bootstrapped/test${COLOR_END}"

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt \";dotty-bootstrapped/compile ;dotty-bootstrapped/test\"" 1>&2
    $SCRIPTS_DIR/sbt ";dotty-bootstrapped/compile ;dotty-bootstrapped/test ;dotty-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/bootstrapCmdTests" 1>&2
    $SCRIPTS_DIR/bootstrapCmdTests
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

community_build() {
    echo "${COLOR_START}sbt community-build/test${COLOR_END}"

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $GIT_CMD submodule sync" 1>&2
    $GIT_CMD submodule sync
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $GIT_CMD submodule update --init --recursive --jobs 7" 1>&2
    $GIT_CMD submodule update --init --recursive --jobs 7
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt community-build/test" 1>&2
    $SCRIPTS_DIR/sbt community-build/test
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

test_sbt() {
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt sbt-dotty/scripted" 1>&2
    $SCRIPTS_DIR/sbt sbt-dotty/scripted
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

test_java11() {
    echo "${COLOR_START}sbt compile and sbt test (Java 11)${COLOR_END}"

    [[ -z "$JDK11_HOME" ]] && ( EXITCODE=1 && return $EXITCODE )
    local OLD_PATH=$PATH
    export PATH="$JDK11_HOME/bin:$PATH"

    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt \";compile ;test\"" 1>&2
    $SCRIPTS_DIR/sbt ";compile ;test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && PATH=$OLD_PATH && return $EXITCODE )

    PATH=$OLD_PATH
    return $EXITCODE
}

documentation() {
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/genDocs" 1>&2
    $SCRIPTS_DIR/genDocs
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    return $EXITCODE
}

archives() {
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $SCRIPTS_DIR/sbt dist-bootstrapped/packArchive" 1>&2
    $SCRIPTS_DIR/sbt dist-bootstrapped/packArchive
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )

    if [[ $DEBUG -eq 1 ]]; then
        echo ""
        echo "Output directory: dist-bootstrapped\target" 1>&2
        ls "$TOOL_HOME/dist-bootstrapped/target"
    fi
    return $EXITCODE
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

TOOL_HOME="$(getHome)"

SCRIPTS_DIR=$TOOL_HOME/project/scripts
[[ -d "$SCRIPTS_DIR" ]] || cleanup 1

ARCHIVES=0
BOOTSTRAPPED=0
CLEAN=0
CLONE=0
COMMUNITY_BUILD=0
COMPILE=0
DEBUG=0
DOCUMENTATION=0
HELP=0
SBT=0
TIMER=0

COLOR_START="[32m"
COLOR_END="[0m"

DEBUG_LABEL="[46m[DEBUG][0m"
ERROR_LABEL="[91mError:[0m"

case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    "msys"*|"cygwin"*|"mingw"*)
        GIT_CMD="$(which git).exe"
        JAVA_CMD="$(which java).exe"
        SBT_CMD="$(which sbt).bat"
        ;;
    *)
        GIT_CMD="git"
        JAVA_CMD="java"
        SBT_CMD="sbt"
        ;;
esac
## sbt build tool requires Java 8+ to be in PATH
if [[ ! -x "$JAVA_CMD" ]]; then
    echo "$ERROR_LABEL Java command not found" 1>&2
    cleanup 1
fi
## dotty is a sbt project
if [[ ! -f "$SBT_CMD" ]]; then
    echo "$ERROR_LABEL sbt build tool not found" 1>&2
    cleanup 1
fi

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

[[ $HELP -eq 1 ]] && help && cleanup

if [[ $CLONE -eq 1 ]]; then
    clone
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $CLEAN -eq 1 ]]; then
    clean
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $COMPILE -eq 1 ]]; then
    test_compiled
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $BOOTSTRAPPED -eq 1 ]]; then
    test_bootstrapped
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $COMMUNITY_BUILD -eq 1 ]]; then
    community_build
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $SBT -eq 1 ]]; then
    test_sbt
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $JAVA11 -eq 1 ]]; then
    test_java11
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $DOCUMENTATION -eq 1 ]]; then
    dcoumentation
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi
if [[ $ARCHIVES -eq 1 ]]; then
    archives
    [[ $EXITCODE -eq 0 ]] || cleanup 1
fi

##############################################################################
## Cleanups

cleanup
