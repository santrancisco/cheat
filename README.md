### WTF is this?

I like [cheat.sh](cheat.sh) idead and wanted to do something similar without bloated python flask server. I also want a simple/quick way to record interesting command snippets without disrupting my work.

There are 2 parts of this:

**.bashrc scripts** contains 2 functions and some environemnt variables for the following purpose:

 - `tnote` function let you keep quick note of  one of 20 previous commands in the history of the current tty, type a new command OR command you store in clipboard
 - This note is saved to `~/terminalnote.md` by default. This is where you want to look into later to sanitise any sensitive data from the command and move the snippet along with its description to the right cheatsheet markdown.
 - `ch` function/command is just a curl wrapper to let you query your cheatsheet.


**runme.sh script** contains build steps to generate a terminal friendly static site from markdown tempaltes.
 
 - `gendoc` will use consolemd to parse all markdown in contents folder and its subdirectory, saving it to public folder along with contents folder subdirectory structure.
 - `pushtosurge` will publish the public folder to surge using whatever domain set in `$CHEATDOMAIN` environment variable.
 - `build` will remove the existing public folder and run `gendoc` + `pushtosurge` together. This is the quickest way to publish your cheatsheets and what you want to trigger using github webhook -> CICD tool.



