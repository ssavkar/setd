#!/bin/bash

# Copyright 2024, Sunil William Savkar <savkar@inthespace.com>
# License: MIT License
#
# setd.sh - directory marks and change directory integration with tab complete (autocomplete)
##

function markstore() {
    declare -x | grep MARKDIR_ >| ~/.bash_markstore
}

function unmark {
    markvariable=MARKDIR_$1
    if [ -v $markvariable ]; then
	unset $markvariable
	markstore
	echo "Mark $1 deleted"
    else
	echo "No such mark $1"
    fi
}

function marklist {
    { echo -e "MARK\tPATHNAME"; echo -e "====\t========"; declare -x | grep MARKDIR_ | cut -d "_" -f2- | sed 's/=/\t/g;s/\"//g'; } | column -t
}

function mark {
    if [[ "$1" =~ ^[[:alnum:]]+$ ]]; then
        markvariable=MARKDIR_$1
	if [ -v $markvariable ]; then
	    read -r -p "Overwrite existing mark [y/N] " response
	    response=${response,,}
	else  
	    response="y"
	fi
	case $response in
	    "y" | "ye" | "yes")
		export MARKDIR_$1=`pwd`
		markstore
		;;
	    *) ;;
	esac
    elif [ -z "$1" ]; then
	marklist
    else
	case $1 in
	    "-l" | "-list")
		marklist
		;;
    	    "-rm" | "-remove" | "-r")
		unmark $2
		;;
    	    "-h" | "-help")
		echo "mark: usage: mark [-l|rm] mark"
		;;
	    *) echo "Unkown option $1"
		;;
	esac
    fi
}

function setd() {
    mark=$(echo "$1" | cut -f1 -d"/")
    remainder=$(echo "$@" | cut -d/ -f2-)
    if [ -v 'MARKDIR_'$mark ]; then
	if [ "$mark" != "$remainder" ]; then
	   cddir="builtin pushd \$MARKDIR_$mark/$remainder"
        else
	   cddir="builtin pushd \$MARKDIR_$mark"
	fi
	eval $cddir > /dev/null
    elif [ -z "$1" ]; then
	builtin pushd ~ > /dev/null
    else
	case $1 in
	    "-1")
		builtin pushd > /dev/null
		;;
    	    "-l" | "-list")
		dirs -v
		;;
	    *) builtin pushd $1 > /dev/null
		;;
	esac
    fi
}

_setd_autocomplete() {
    if [[ "${#COMP_WORDS[@]}" != "2" ]]; then
        return
    fi
    local words=$(declare -x | grep MARKDIR_ | cut -d "_" -f2- | cut -f1 -d "=")
    COMPREPLY=($(compgen -W "$words" "${COMP_WORDS[1]}"))
}

# If you do not want to override built in `cd` functionality, then comment out this function.
function cd() {
    setd $1
}

# Source mark directory environment variables

if [ -f ~/.bash_markstore ]; then
    . ~/.bash_markstore
fi

# Set up function for complete for both setd and mark

complete -d -X '.[^./]*' -F _setd_autocomplete setd
complete -d -X '.[^./]*' -F _setd_autocomplete cd
complete -F _setd_autocomplete mark
