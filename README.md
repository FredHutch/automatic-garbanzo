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

