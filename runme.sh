#!/bin/bash
##Folder structure should be:
## ____runme.sh
##  |__./contents/hello.md
##  |__./contents/linux/vim.md
##  |__./contents/python/asyncio.md
##  |__./public

## After the code run, we will get public folder look like this:
##  |__./public/index.html
##  |__./public/hello
##  |__./public/linux/vim
##  |__./pugblic/python/asyncio
##
## This is a good template for a bash script with multiple tasks


which consolemd &> /dev/null
[ $? -eq 0 ] || { echo "consolemd does not exist, please run 'pip3 install consolemd'"; exit 1; }


# Bail if there is an error
set -e
# Uncomment line below if you want to see the command being run
# set -x
# Change to the directory of the script
cd "$(dirname "$0")"

# set trap to always call cleanup function whether it fails or not
trap cleanup EXIT
# Note: trap can be used with signal number, eg "trap cleanup 9" will only be called on sigkill 
# Run `trap -l` to know what the list of all signals are.

#cleanup function is called at the end of the script whether it fails or not
function cleanup {
    echo "Fin."
    #echo "[+] cleanup code was called"
}

WORKINGDIR=$0
PUBLICFOLDER='public'

function convertdoc {
    echo "[+] Convert all notes"
    FILENAME=$1
    BASENAME=`basename $FILENAME .md`
    DIRNAME=`dirname $FILENAME`
    DESTINATIONFOLDER=`echo ../$PUBLICFOLDER/$DIRNAME`
    DESTINATIONFILE=`echo $DESTINATIONFOLDER/$BASENAME`
    echo "[+] Converting $FILENAME" 
    mkdir -p $DESTINATIONFOLDER
    cat $FILENAME | consolemd > $DESTINATIONFILE
    echo "$DIRNAME/$BASENAME" |sed 's/^\.\//\//g' >> ../$PUBLICFOLDER/index.html
}

export -f convertdoc

# Try calling this with ./task.sh callme Whatever
function gendoc {
    CONTENTFOLDER='contents'
    cd $CONTENTFOLDER
    echo "" > ../$PUBLICFOLDER/index.html
    echo "[+] Going into folder $CONTENTFOLDER" 
    if [ -z "${FILES:-}" ]; then
        find ./ -name '*.md' -exec bash -c "PUBLICFOLDER=$PUBLICFOLDER convertdoc {}" \;
    fi
    cd ..
}

function pushtosurge {
    echo "[+] Pushing to surge"
    surge $PUBLICFOLDER -d $CHEATDOMAIN
}

function build {
    if [ -d "$PUBLICFOLDER" ]; then
        rm -rIv $PUBLICFOLDER
    fi
    mkdir -p $PUBLICFOLDER
    gendoc
    pushtosurge
}

function help {
   echo "$0 <task> <args>"
   echo "Tasks: "
   compgen -A function | egrep -v 'cleanup|help|convertdoc' |cat -n
}


# execute the function and arguments pass to this script.
# If nothing provided, run help function
set -e
${@:-help}

