# Roles

## Configuring Role Upload

If you are building a role cookbook an additional (manual) change is required
to configure automatic-garbanzo to upload the role object to the Chef server.
Edit the Jenkinsfile and uncomment the line indicating `rake build_role`

Be sure to commit this change.  Note that updating automatic-garbanzo will
override this change: you'll have to restore this after running the update
script

## Workflow

Role cookbooks are indistinguisible from "regular" cookbooks but are used as
the only item in a role policy object's `run_list`.  For example, if we have a
role called `scicomp-role-foo` there is a role policy object on the Chef server
called `scicomp-role-foo` with a run list of:

    recipe[scicomp-role-foo::default]

The workflow implemented in the automatic garbanzo is thus:

 - use foodcritic and rubocop to check syntax
 - use Testkitchen to verify successful converge on test platforms
 - if the branch being built is named `prod`, upload a new
   artifact to the server and supermarket
 - if the branch being built is named `prod`, upload a role
   policy object to the server

