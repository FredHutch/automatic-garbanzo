# Using this file

1. Add this repo as a submodule:

`git submodule add https://github.com/FredHutch/automatic-garbanzo.git .jenkins`

1. Copy `.jenkins/skel/Jenkinsfile` to the root of your cookbook
1. Configure automation using `cd .jenkins/tools && ./configure.sh <org> <reponame>`
1. Commit all the changes and push

