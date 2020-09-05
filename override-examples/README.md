# packer-template user variable overrides

This folder contains several different override files and examples of how these can be used to pass in values for user variables when running a build. See [project wiki](https://github.com/artislismanis/packer-template/wiki/User-Variables) for further details on user variables used in project's build definitions.

## Providing overrides on the command line

There are two main mechanisms to override default user variable values on the command line: a) pass in overrides for individual variables or b) pass in an override file containing multiple overrides. Both options can be combined and the same option can be used multiple times to chain overrides. Overrides with the same key that are specified later will override ones that were specified earlier.

You can override specific user variables directly on the command line like so:

```powershell
packer build --var "vm_name=coolName" ubuntu-20.04-server-base.json
```

An override JSON file can be specified like this:

```powershell
packer build --var-file custom-overrides.json ubuntu-20.04-server-base.json
```

You can combine the both approaches like shown below. If custom-overrides.json in the example below contains variable override for `vm_name` this will be replaced by value specified on the command line via direct variable override as this was specified after defining the override file.

```powershell
packer build --var-file custom-overrides.json `
    --var "vm_name=coolName" ubuntu-20.04-server-base.json
```

And you can go completely crazy with this:

```powershell
packer build --var-file custom-overrides.json `
    --var-file some-more-custom-overrides.json `
    --var "vm_name=coolName" `
    --var-file final-custom-overrides.json `
    --var "vm_lv_initial_size=8192" ubuntu-20.04-server-base.json
```

## Example scenarios

You can keep overrides in a single file or keep these modular and combine as necessary. Below is an overview of example override files and some scenarios of how you could use these.

| Override file |Notes |
| --- | --- | --- |
| **all-overrides.json** | Provides an example of overriding all user variables is a single override file. Contains the defaults implemented in `lubuntu-20.04.json` build definition and easy to modify.|
| **auto-secret-overrides.json** | Demonstrates creation of a customised user account and forcing regeneration of all secrets as the template box gets provisioned. Makes use of custom Vagrantfile template that helps manage login details when using the template to create Vagrant boxes. |
| **box-overrides.json** | Demonstrates how to override various variables related to configuring the box build. Allows you to use the same base template but apply extra customisations for specific builds. |
| **user-overrides.json** | Override that shows how to create a custom default system user with your supplied secrets (password and SSH key). Great for creating more secure boxes that don't use the same user and secrets as public Vagrant templates. |
| **vagrant-cloud-overrides.json** | Override for specifying Vagrant Cloud details. `lubuntu-20.04.json` template has been set up to read Vagrant Cloud configuration from specific environmental variables. You can override this behaviour and specify the required details in an override file. You can flexibly choose which variables you override and for which you keep the default behaviour. |

Code examples below will work with the project templates assume you run these from the project folder root. Review and adjust override file content before running the build.

Providing all overrides in a single file:

```powershell
packer build --except=publish-vc --var-file .\override-examples\all-overrides.json `
    lubuntu-20.04.json
```

Providing all overrides in a single file and tweaking an individual overrides on the command line:

```powershell
packer build --except=publish-vc --var-file .\override-examples\all-overrides.json `
    --var "vm_name=lubuntu-all-overrides-test-vm" lubuntu-20.04.json
```

Combining multiple more modular override files (separating out box, user and Vagrant Cloud configuration - together these cover off most of overrides available):

```powershell
packer build --var-file .\override-examples\box-overrides.json `
    --var-file .\override-examples\user-overrides.json `
    --var-file .\override-examples\vagrant-cloud-overrides.json `
    --var "vm_name=lubuntu-modular-overrides-test-vm" lubuntu-20.04.json
```

For an alternative way to specify overrides see `variables` section in **lubuntu-20.04.json** build definition. Specifically refer to user variables `vagrant_cloud_tag`, `vagrant_cloud_token` and `vagrant_cloud_version`. These pull their default values from the specified environment variables. Note that this functionality is only available directly in the build definition and will not work if you try to reference environmental variables in the overrides file.
