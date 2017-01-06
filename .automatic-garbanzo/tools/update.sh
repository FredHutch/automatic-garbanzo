#!/bin/bash

# Update automatic garbanzo- run from top level of repository

if [ ! -d ".git" ] 
then
        echo "Run update script from the top level of your repository" >&2
        exit 1
fi

# Get latest release URL for download

URL=$(curl -sS https://api.github.com/repos/FredHutch/automatic-garbanzo/releases/latest  |jq -r '.tarball_url')
RELEASE=$(basename ${URL})

# Stash current changes so we can commit this update

git stash save 'automatic-garbanzo update'

# Download and Extract

# Note- we could just `curl | tar` to extract directly without the tempfile but
# we'd like to get the files committed as part of the process and thus need the
# manifest of the tarball.

# There's also a way to do it as a oneliner, but there lies madness

DIR=$(mktemp -d)
OUTPUT=${DIR}/automatic-garbanzo-${RELEASE}.tgz
curl -sS -o ${OUTPUT} -L ${URL} 
tar -xzv --strip-components=1 -f ${OUTPUT}

# Stamp release and commit

echo ${RELEASE} > .automatic-garbanzo/RELEASE
git add .automatic-garbanzo/RELEASE

manifest=($(tar tf ${OUTPUT}))

for target in "${manifest[@]}"
do
        echo git add ${target#*/}
        git add ${target#*/}
done

git commit -m "Updated automatic garbanzo to release ${RELEASE}"
git stash apply stash^{/automatic-garbanzo}
git stash drop $(git stash list |awk -F: '/automatic-garbanzo/{print $1}')

echo "Update complete for this branch"
