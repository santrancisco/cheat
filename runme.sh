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
    echo "[$DIRNAME/$BASENAME](https://$CHEATDOMAIN/index.html?f=/web/$FILENAME)" |sed 's/^\.\//\//g' >> ../$PUBLICFOLDER/index.md
    echo "$DIRNAME/$BASENAME" |sed 's/^\.\//\//g' >> ../$PUBLICFOLDER/list.txt
}

export -f convertdoc

# Try calling this with ./task.sh callme Whatever
function gendoc {
    echo "" > $PUBLICFOLDER/index.md
    echo "" > $PUBLICFOLDER/list.txt
    CONTENTFOLDER='contents'
    cd $CONTENTFOLDER
#    echo "<h1>This site should only be access via curl.:)</h1>" > ../$PUBLICFOLDER/index.html
#    printf '\033[2J Below is the list of available cheatsheets:\n' >> ../$PUBLICFOLDER/index.html
    echo "[+] Going into folder $CONTENTFOLDER" 
    if [ -z "${FILES:-}" ]; then
        find ./ -name '*.md' -exec bash -c "PUBLICFOLDER=$PUBLICFOLDER convertdoc {}" \;
    fi
    echo "[+] Generate web version"
    cd ..
    cp $CONTENTFOLDER/index.html $PUBLICFOLDER/index.html
    mkdir -p $PUBLICFOLDER/web
    echo "[+] Copy markdown files to publish web folder"
    cp -rf $CONTENTFOLDER/* $PUBLICFOLDER/web/ 
}

function add_autocomplete {
    # Just gonna grep for all lines starting with / and shove it in our bash completion cause i'm lazy :)
    autocomplete=$(cat $PUBLICFOLDER/list.txt | grep '^\/' | tr '\n' ' ')
    # Adding auto complete into .bash_completion 
    if [ ! -f $HOME/.bash_completion ]; then
        echo "[+] Creating .bash_completion in $HOME"
        echo "#!/usr/bin/env bash" > $HOME/.bash_completion 
    fi

    if $(grep -q '##CHBASHCOMPLETION##' $HOME/.bash_completion); then 
        echo "[+] Found existing .bash_completion entry!"
    else
        echo "[+] Create new .bash_completion entry!"
        echo "##CHBASHCOMPLETION##" >> $HOME/.bash_completion 
        echo "" >> $HOME/.bash_completion 
    fi
    autocomplete=$(echo complete -W \"$autocomplete\" ch )
    echo "[+] Adding new ch bash completion in .bash_completion"
    sed -i '/##CHBASHCOMPLETION##/!b;n;cREPLACELINEMARKER' $HOME/.bash_completion
    sed -i "s|REPLACELINEMARKER|$autocomplete|g" $HOME/.bash_completion
}

function pushtosurge {
    echo "[+] Pushing to surge"
    surge $PUBLICFOLDER -d $CHEATDOMAIN
}

function build_without_autocomplete {
    if [ -d "$PUBLICFOLDER" ]; then
        rm -rIv $PUBLICFOLDER
    fi
    mkdir -p $PUBLICFOLDER
    gendoc
    pushtosurge
}


function build {
    if [ -d "$PUBLICFOLDER" ]; then
        rm -rIv $PUBLICFOLDER
    fi
    mkdir -p $PUBLICFOLDER
    gendoc
    add_autocomplete
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
