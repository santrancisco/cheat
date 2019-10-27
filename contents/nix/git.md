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

create a new localbranch to track local changes and push it to github to track it in a new branch

```bash
    git checkout -b sanmessingaround
    git add 
    git commit "messing around"
    git push -u origin sanmessingaround
```
Make your changes… To catch up with master:

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

##############################################
# Text editor open                           #
# "pick" the top commit to squash everything #
# underneath it with "squash - save the file #
##############################################

git push -f origin
```