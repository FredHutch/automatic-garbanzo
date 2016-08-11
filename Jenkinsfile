#!/usr/bin/env groovy
def go() {
    stage 'Stage: SCM Checkout'
    checkout scm
    stage 'Stage: Smoke Tests'
    echo 'Running foodcritic against recipes'
    sh '''
        eval "$(chef shell-init sh)"
        foodcritic ./recipes
    '''
    echo 'Running rubocop'
    sh '''
        eval "$(chef shell-init sh)"
        rubocop
    '''
    stage 'Stage: Integration Testing'
    echo 'Starting Test Kitchen'
    sh '''
        eval "$(chef shell-init sh)"
        kitchen verify
    '''
    stage 'Stage: Upload Check'
    // Upload cookbook to supermarket if:
    //    - it is on the production branch
    //    - it has a new version (i.e. DNE in
    //      market or server)
    if ( env.BRANCH_NAME == 'prod' ) {
        echo "Branch is eligible for upload- checking"
        sh '''
            eval "$(chef shell-init sh)"
            VERSION=$(knife metadata version)
            NAME=$(knife metadata name)
            knife cookbook show ${VERSION} >/dev/null 2>&1 && ( \
                echo "Version ${VERSION} of ${NAME} exists on server";\
                echo "Aborting";\
                exit 1 ) || ( echo "${VERSION} DNE on server" )
            knife supermarket show ${VERSION} >/dev/null 2>&1 && ( \
                echo "Version ${VERSION} of ${NAME} exists in market";\
                echo "Aborting";\
                exit 1 ) || ( echo "${VERSION} DNE in supermarket" )
            echo "Tagging version"
            git tag ${VERSION}
            git push --tags
            eval "$(chef shell-init sh)"
            git checkout ${VERSION}
            knife supermarket share -o .. $(knife metadata name)
            berks install
            berks update
            berks upload
            if $(git ls-files Berksfile.lock --error-unmatch 1>/dev/null 2>&1);\
            then \
                echo "applying environment $(knife metadata name)" ;\
                berks apply $(knife metadata name); \
            fi
        '''
    } else {
        echo "Skipping upload (on branch ${env.BRANCH_NAME})"
    }
}
return this;
