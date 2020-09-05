# testing packer-template builds

## What is this?

This folder includes a couple of quick PowerShell scripts to build various versions of boxes for testing, add these to your Vagrant environment and then clean up after testing has been done. All the output is redirected to per-build log file in **logs** folder alongside a more generic build-time.log capturing end-to-end run time of each individual build.

## Why do I need it?

This is mostly for checking that any changes to the project code still produce working Vagrant boxes and that these operate as expected. At the moment the actual testing is manual.

## OK, how do I get started?

To run all test build definitions enter PowerShell and from project root run the following command:

```powershell
.\test\test-builds.ps1
```

You can be selective and specify a list of one or more specific builds like so:

```powershell
.\test\test-builds.ps1 -tests ubuntu-base-vagrant,ubuntu-base-alt
```

The test names should match your test build definitions specified in the **test-builds.ps1** file. Please note that **lubuntu-vagrant-cloud** test build requires you to set some environmental variables to specify Vagrant Cloud configuration (see project readme). If you are using PowerShell you can do something like this:

```powershell
$env:VC_TAG="artislismanis/lubuntu-20.04"
```

## I've done my test builds, what now?

Here are some of the key steps I go through to test my boxes:

1. Create a basic Vagrant VM using each of the builds. To do this, create an appropriately named folder and initialise VM using the selected build. For example, to initialise Vagrant VM based on **ubuntu-base-vagrant** run thw following command in the root of the folder you created:

    ```powershell
    vagrant init ubuntu-base-vagrant
    ```

2. Test that the Vagrantfile templates included with your box function as expected. Are you prompted to install all specified plugins? Are any other configuration settings working as expected?

3. If you are using custom user details rather than Vagrant defaults, are these working as expected?

4. Are the key software packages that you pre-installed all available and working as expected?

5. If you are using post-processors to publish your builds, are these working as expected?
