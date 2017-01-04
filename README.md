# Using this file

1. Add this repo as a submodule:

`git submodule add https://github.com/FredHutch/automatic-garbanzo.git .jenkins`

1. Copy `.jenkins/skel/Jenkinsfile` to the root of your cookbook

```
$  export PW=<your password>
$ export USER=<your github username>
$ cd .jenkins/tools && ./configure.sh <org> <reponame>
```
1. Commit all the changes and push
2. Repeat for each branch that should have a project
3. Add a multibranch project in Jenkins

# Updating

To update your local checkout of the automatic garbanzo, run the following:

```
cd .jenkins
git pull --rebase
cd ..
git commit -m "your notes here" -a
```

The `rebase` seems necessary to prevent merging changes from upstream, which results in a commit that would need to be pushed back to the origin.
