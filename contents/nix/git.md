## Pentest

*Use `--depth 1` to ignore history when doing git clone*

Branch whenever we start pantest:

```bash
### Create local branch for myself where we add/commit all our changes
git branch san_local
### checkout our local branch
git checkout san_local
### List out all branches and see the one we like
git branch -a
### merge with the feature we wanna test
git merge remotes/origin/feat/cert-auth
```

----------

## Dev

create a new `sanmessingaround` local branch to track local changes and push it to remote branch in github to track it and work with others

```bash
    git checkout -b sanmessingaround
    git add 
    git commit "messing around"
    git push origin sanmessingaround --set-upstream
    ## Update the current 
    git pull origin main
```

After making your changes & you want to catch up with master:

```bash
    git checkout master; 
    git pull; 
    git checkout sanmessingaround; 
    git merge master
```


To ignore file mode changes `git config core.fileMode false`. Reverse all filemode changes:

```bash
git diff -p -R --no-color \
    | grep -E "^(diff|(old|new) mode)" --color=never  \
    | git apply
```

**Squash a bunch of commits using rebase**

If you want to squash every commit from commit `9358e6cad6944f09bc1aa51d9a7cf3fc262da952`, first run git rebase, pick/squash commit then force push to 22

```bash
git rebase -i 9358e6cad6944f09bc1aa51d9a7cf3fc262da952

#################################################
# Text editor open                              #
# "pick" the top commit to squash everything    #
# underneath it with "squash" thensave the file #
#################################################

git push -f origin
```

**Update a forked project**

```bash
# Add the remote, call it "upstream":
git remote add upstream https://github.com/whoever/whatever.git

# Fetch all the branches of that remote into remote-tracking branches,
# such as upstream/master:
git fetch upstream

# Make sure that you're on your master branch:
git checkout master

# Rebase your master
git rebase upstream/master

# Push the change to our master
git push -f origin master
```

**Useful commands**

`git log --graph` Shows graph lines with commits, branches.
`git diff --stat` Shows stat about files changes
`git log --grep="search string"` Search git log for interesting commits.
`git config --get remote.origin.url` Get remote URL of repo
`git remote show origin` Get full output about remote git
`git status --ignored`  Show modified files as well as ignored files
`git grep AWS_ACCESS_KEY_ID $(git rev-list --all)` Search all previous commits for AWS key
`git stash` and `git stash drop` or `git stash pop` is useful to merge /drop local changes before pulling latest version

3 useful commands to exclude local changes, re-include and list what are excluded:

 - `git update-index --assume-unchanged {filename}`
 - `git update-index --no-assume-unchanged {filename}`
 - `git ls-files -v`

2 commands to publish the folder `web` as github page by creating a subtree branch. 2nd command force update to gh-pages branch when you mess around with branches.

 - `git subtree push --prefix web origin gh-pages`
 - `git push origin `git subtree split --prefix web master`:gh-pages --force`

 ## Steps to fork, dev then make pull rquest

 1 - fork to your account
 2 - `git clone git@github.com:santrancisco/forkedprojectname.git`
 3 - set up stream to original to keep our local copy up-to-date with changes: `git remote add --track master upstream git@github.com:orgin-org/projectname.git` ,  `git fetch upstream`
 4 - `git checkout -b my-branch-name upstream/master`
 5 - Make changes! then `git add`, `git commit`
 6 - Push our branch up `git push -u origin my-branch-name`
 7 - Visit original repositories and click on "Compare & Pull request"
 8 - ` git pull origin master` to pull update from master

 ## CodeQL

 1 - Pull codeql docker `docker pull mcr.microsoft.com/cstsectools/codeql-container`
 2 - `docker run --rm --name codeql-container mcr.microsoft.com/codeql/codeql-container -v {dir_to_analyse}:/opt/src  -v {dir_to_result}:/opt/results -e CODEQL_CLI_ARGS=<query run...>`