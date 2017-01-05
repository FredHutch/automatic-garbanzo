#!/usr/bin/env groovy
def go() {
    stage 'Stage: SCM Checkout'
    checkout scm
    stage 'Stage: Smoke Tests'
    sh '''
        eval "$(chef shell-init sh)"
        rake test
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
            rake build_cookbook
        '''
    } else {
        echo "Skipping upload (on branch ${env.BRANCH_NAME})"
    }
}
return this;
