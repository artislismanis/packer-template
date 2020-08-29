# packer-template user variable overrides

See [project wiki](https://github.com/artislismanis/packer-template/wiki/User-Variables) for further details on available user variables.

Provided templates:

**all-overrides.json** - Provides and example of overriding all user variables is a single override file.

**auto-secret-overrides.json** -Demonstrates creation of a customised user account and forcing regeneration of all secrets as the template gets provisioned.

**box-overrides.json** - Demonstrates how to override various variables related to configuring the box build.

**user-overrides.json** - Shows how to create default user with supplied secrets.

**vagrant-cloud-overrides.json** - Override for specifying Vagrant Cloud box publishing details.

Chain overrides, combine in the same file, override individual variables command line. 