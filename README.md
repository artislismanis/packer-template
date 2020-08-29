# packer-template

## What is this?

This is a [Packer](https://www.packer.io/) template to help you generate a custom [Vagrant](https://www.vagrantup.com/) / [VirtualBox](https://www.virtualbox.org/) box image based on the latest release of [Ubuntu LTS](https://releases.ubuntu.com/). It starts with a minimal Ubuntu Server install, enables OpenSSH for remote shell access and then uses provisioning scripts to build up required box templates from leaving minimal Ubuntu server minimal, to installing some useful tooling, to setting up a desktop environment. [lubuntu-datadev-vm](https://github.com/artislismanis/lubuntu-datadev-vm) uses this Packer project as a starting point.

The code has been tested and working using [Packer 1.6.2](https://releases.hashicorp.com/packer/1.6.2/) and [VirtualBox 6.1.12](https://download.virtualbox.org/virtualbox/6.1.12/) on a Windows 10 machine with Ubuntu Server 20.04.1 LTS ISO.

## Why do I need it?

Rolling your own base box gives you full control and transparency over what goes into it - you can optimise your template to your specific needs. It is also an opportunity to lock down your box template from security perspective by not using insecure accounts and secrets used in publicly available downloads.

## OK, how do I get started?

1. Make sure you have a recent version of Packer and VirtualBox installed and working on your system.

2. Clone or download this repository.

    ```shell
    git clone git://github.com/artislismanis/packer-template.git
    ```

3. Download the relevant [Ubuntu Server ISO](https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-live-server-amd64.iso) installation media into the `iso` folder, make note of the related [checksums](https://releases.ubuntu.com/20.04.1/SHA256SUMS).

4. Review the Packer template you want to use (this example uses `ubuntu-20.04-server-base.json`):
    1. Modify VM specification in `vboxmanage` section to match your available system resources. These are standard VirtualBox VBoxManage commands - see [VirtualBox manual](https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm) for full reference.
    2. Review user variables in `variables` section. Make sure `vm_iso_image`, `vm_iso_image_checksum` and `vm_iso_image_checksum_type` have the correct values assigned. Make other adjustments as required. Variables can be set in the template file or managed through runtime overrides like described in these [Packer examples](https://www.packer.io/docs/templates/user-variables/#setting-variables). See [project wiki](https://github.com/artislismanis/packer-template/wiki/User-Variables) for further details on available user variables.

5. Run packer build in the root of the repository folder.

    ```shell
    packer build ubuntu-20.04-server-base.json
    ```

    Or overriding default user variables using an overrides file.

    ```shell
    packer build --var-file=custom-overrides.json ubuntu-20.04-server-base.json
    ```

    Or overriding specific user variables directly on the command line.

     ```shell
    packer build --val "vm_name=coolName" ubuntu-20.04-server-base.json
    ```

6. Wait for the build to finish. End to end build of minimal Ubuntu Server box using the specified VM configuration takes under 15 minutes, Lubuntu Desktop under 50 minutes. The output is saved in `box/virtualbox/` folder and can be used with `vagrant box add` as described in [Vagrant CLI documentation](https://www.vagrantup.com/docs/cli/box.html#box-add).

## What else?

The project provides two templates `ubuntu-20.04-server-base.json` and `lubuntu-20.04.json`. `lubuntu-20.04.json` includes Vagrant Cloud post-processor and will fail if used without specifying valid Vagrant Cloud details & key in user variables section. You can exclude the post-processor form running by triggering build like so:

 ```shell
packer build --except=publish-vc lubuntu-20.04.json
```

If you do want to build and publish your box to Vagrant Cloud the template expects you to specify tag, token and version in `VC_TAG`, `VC_TOKEN` and `VC_VERSION` environmental variables respectively.

The project has some rudimentary test build scripts and brief documentation to help with testing - check out the notes on [testing](test/testing.md) for more details.

Over time [project wiki](https://github.com/artislismanis/packer-template/wiki) will be evolved to include more detail and troubleshooting information. In the meantime check out 'Useful Resources' section below if you get stuck.

## Useful Resources

- [Packer Documentation](https://www.packer.io/docs/)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Ubuntu Wiki - Automated Server Installs](https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls)
- [Vagrant Documentation](https://www.vagrantup.com/docs/)
