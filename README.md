### What is this?

*UPDATE: I finally bother to add webview capability.It is literally just a HTML page that loads and renders markdown file directly*

To read in more details and my frustration with remembering things, visit my [blog post](https://blog.ebfe.pw/posts/terminalnote.html).

I like [cheat.sh](https://cheat.sh) idea and wanted to do something similar without running a python flask server just for that. I also want a simple/quick way to record interesting commands right in my terminal during my work so i put this together.

### Requirement


I use surge.sh(`npm install --global surge`) to serve the cheat file. you can replace the pushtosurge function in runme.sh to scp the file to your server or push it back to git page, upload to S3,etc... 
I also use consolemd(`pip install consolemd`) to convert the markdown note to pretty terminal format.

### What the script does

There are 2 parts for this setup:

**.bashrc scripts** contains 2 functions and some environment variables for the following purpose:

 - `tnote` function let you quickly note down a command and short description of what it does while working in bash. It let you pick one of the 20 previous commands in bash history or type your own command OR a command you copied in clipboard.
 - This note is saved to `~/terminalnote.md` by default. This is where you want to look into later once a week to sanitise any sensitive data from the command and move the snippet along with its description to the right cheatsheet markdown.
 - `ch` function/command is just a curl wrapper to your specific cheatsheet url.


**runme.sh script** contains build steps to generate a terminal friendly static site from markdown tempaltes.
 
 - `gendoc` will use consolemd to parse all markdown in contents folder and its subdirectory, saving it to public folder along with contents folder subdirectory structure.
 - `pushtosurge` will publish the public folder to surge using whatever domain set in `$CHEATDOMAIN` environment variable.
 - `build` will remove the existing public folder and run `gendoc` + `pushtosurge` together. This is the quickest way to publish your cheatsheets and what you want to trigger using github webhook -> CICD tool.
 - `build_with_autocomplete` Same as build but also add entry to `~/.bash_completion` for cli autocomplete.


And that is it, you can delete everything i have in contents and replace it with yours. These are just some of my random cheatsheets i recorded in the last month or 2. You can start writing your own markdown and your own folder structure.

