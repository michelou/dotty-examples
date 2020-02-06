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

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    if $TIMER; then
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total elapsed time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=true && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -debug) DEBUG=true ;;
        -help)  HELP=true ;;
        -timer) TIMER=true ;;
        -*)
            echo "$ERROR_LABEL Unknown option $arg" 1>&2
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        arch|archives)     CLONE=true & COMPILE=true & BOOTSTRAPPED=true & ARCHIVES=true ;;
        boot|bootstrap)    CLONE=true & COMPILE=true & BOOTSTRAPPED=true ;;
        clean)             CLEAN=true ;;
        clone)             CLONE=true ;;
        community)         COMMUNITY_BUILD=true ;;
        compile)           COMPILE=true ;;
        doc|documentation) COMPILE=true & BOOTSTRAPPED=true & COMMUNITY_BUILD=true & DOCUMENTATION=true ;;
        help)              HELP=true ;;
        java11)            CLONE=true & JAVA11=true ;;
        *)
            error "$ERROR_LABEL Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "BOOTSTRAPPED=$BOOTSTRAPPED CLEAN=$CLEAN CLONE=$CLONE COMPILE=$COMPILE HELP=$HELP TIMER=$TIMER"
    # See http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
    $TIMER && TIMER_START=$(date +"%s")
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
    debug "$GIT_CMD submodule sync"
    $GIT_CMD submodule sync
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$GIT_CMD submodule update --init --recursive --jobs 7"
    $GIT_CMD submodule update --init --recursive --jobs 7
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

clean() {
    echo "${COLOR_START}run sbt clean and git clean -xdf${COLOR_END}"

    debug "$SCRIPTS_DIR/sbt clean"
    $SCRIPTS_DIR/sbt clean
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$GIT_CMD clean -xdf --exclude=*.bat --exclude=*.ps1 --exclude=*.sh"
    $GIT_CMD clean -xdf --exclude=*.bat --exclude=*.ps1 --exclude=build.sh
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

test_compiled() {
    echo "${COLOR_START}sbt compile and sbt test${COLOR_END}"

    debug "$SCRIPTS_DIR/sbt \";compile ;test\""
    $SCRIPTS_DIR/sbt ";compile ;test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$SCRIPTS_DIR/cmdTests"
    $SCRIPTS_DIR/cmdTests
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

test_bootstrapped() {
    echo "${COLOR_START}sbt dotty-bootstrapped/compile and sbt dotty-bootstrapped/test${COLOR_END}"

    debug "$SCRIPTS_DIR/sbt \";dotty-bootstrapped/compile ;dotty-bootstrapped/test\""
    $SCRIPTS_DIR/sbt ";dotty-bootstrapped/compile ;dotty-bootstrapped/test ;dotty-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$SCRIPTS_DIR/bootstrapCmdTests"
    $SCRIPTS_DIR/bootstrapCmdTests
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

community_build() {
    echo "${COLOR_START}sbt community-build/test${COLOR_END}"

    debug "$GIT_CMD submodule sync"
    $GIT_CMD submodule sync
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$GIT_CMD submodule update --init --recursive --jobs 7"
    $GIT_CMD submodule update --init --recursive --jobs 7
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    debug "$SCRIPTS_DIR/sbt community-build/test"
    $SCRIPTS_DIR/sbt community-build/test
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    return true
}

test_sbt() {
    debug "$SCRIPTS_DIR/sbt sbt-dotty/scripted"
    $SCRIPTS_DIR/sbt sbt-dotty/scripted
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return $EXITCODE )
}

test_java11() {
    echo "${COLOR_START}sbt compile and sbt test (Java 11)${COLOR_END}"

    [[ -z "$JDK11_HOME" ]] && EXITCODE=1 && return 0
    local OLD_PATH=$PATH
    export PATH="$JDK11_HOME/bin:$PATH"

    debug "$SCRIPTS_DIR/sbt \";compile ;test\""
    $SCRIPTS_DIR/sbt ";compile ;test"
    [[ $? -eq 0 ]] || ( EXITCODE=1 && PATH=$OLD_PATH && return 0 )

    PATH=$OLD_PATH
}

documentation() {
    debug "$SCRIPTS_DIR/genDocs"
    $SCRIPTS_DIR/genDocs
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

archives() {
    debug "$SCRIPTS_DIR/sbt dist-bootstrapped/packArchive"
    $SCRIPTS_DIR/sbt dist-bootstrapped/packArchive
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )

    if $DEBUG; then
        echo ""
        echo "Output directory: dist-bootstrapped\target" 1>&2
        ls "$TOOL_HOME/dist-bootstrapped/target"
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

TOOL_HOME="$(getHome)"

SCRIPTS_DIR=$TOOL_HOME/project/scripts
[[ -d "$SCRIPTS_DIR" ]] || cleanup 1

ARCHIVES=false
BOOTSTRAPPED=false
CLEAN=false
CLONE=false
COMMUNITY_BUILD=false
COMPILE=false
DEBUG=false
DOCUMENTATION=false
JAVA11=false
HELP=false
SBT=false
TIMER=false

COLOR_START="[32m"
COLOR_END="[0m"

case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    "msys"*|"cygwin"*|"mingw"*)
        GIT_CMD="$(which git).exe"
        JAVA_CMD="$(which java).exe"
        SBT_CMD="$(which sbt).bat"
        ;;
    *)
        GIT_CMD="$(which git)"
        JAVA_CMD="$(which java)"
        SBT_CMD="$(which sbt)"
        ;;
esac
## sbt build tool requires Java 8+ to be in PATH
if [[ ! -x "$JAVA_CMD" ]]; then
    error "Java command not found"
    cleanup 1
fi
## dotty is a sbt project
if [[ ! -f "$SBT_CMD" ]]; then
    error "sbt build tool not found"
    cleanup 1
fi

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

$HELP && help && cleanup

if $CLONE; then
    clone || cleanup 1
fi
if $CLEAN; then
    clean || cleanup 1
fi
if $COMPILE; then
    test_compiled || cleanup 1
fi
if $BOOTSTRAPPED; then
    test_bootstrapped || cleanup 1
fi
if $COMMUNITY_BUILD; then
    community_build || cleanup 1
fi
if $SBT; then
    test_sbt || cleanup 1
fi
if $JAVA11; then
    test_java11 || cleanup 1
fi
if $DOCUMENTATION; then
    documentation || cleanup 1
fi
if $ARCHIVES; then
    archives || cleanup 1
fi

##############################################################################
## Cleanups

cleanup
