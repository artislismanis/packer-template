# packer-template

## What is this?

This is a [Packer](https://www.packer.io/) template to help you generate a custom [Vagrant](https://www.vagrantup.com/) / [VirtualBox](https://www.virtualbox.org/) box image based on the latest release of [Ubuntu LTS](https://releases.ubuntu.com/). It starts with a minimal Ubuntu Server install, enables OpenSSH for remote shell access and then uses provisioning scripts to build up required box templates from leaving minimal Ubuntu server minimal, to installing some useful tooling, to setting up a desktop environment.

The code has been tested and working using [Packer 1.5.5](https://releases.hashicorp.com/packer/1.5.5/) and [VirtualBox 6.1.6](https://download.virtualbox.org/virtualbox/6.1.6/) on a Windows 10 machine with the initial release of Ubuntu Server 20.04 LTS.

## Why do I need it?

Rolling your own base box gives you full control and transparency over what goes into it - you can optimise your template to your specific needs. It is also an opportunity to lock down your box template from security perspective by not using insecure accounts and secrets used in publicly available resources.

## OK, how do I get started?

1. Make sure you have a recent version of Packer and VirtualBox installed and working on your system.

2. Clone or download this repository.

    ```shell
    git clone git://github.com/artislismanis/packer-template.git
    ```

3. Download the relevant [Ubuntu Server ISO](https://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso) installation media into the `iso` folder, make note of the related [MD5 checksum](https://releases.ubuntu.com/20.04/MD5SUMS).

4. Review `ubuntu-20.04-server-base.json`:
    1. Make sure `iso_checksum` and `iso_url` variables in builders section have the correct values assigned based on the previous step.
    2. Modify VM specification in `vboxmanage` section to match your available system resources. These are standard VirtualBox VBoxManage commands - see [VirtualBox manual](https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm) for full reference.
    3. Review `variables` section that specifies user to be created for provisioning. By default the template will create standard insecure Vagrant user. These details can be changed directly in the template file or managed through runtime overrides like described in these [Packer examples](https://www.packer.io/docs/templates/user-variables/#setting-variables).

5. Run packer build in the root of the repository folder.

    ```shell
    packer build ubuntu-20.04-server-base.json
    ```

    Or overriding default user variables using overrides file.

    ```shell
    packer build --var-file=custom-overrides.json ubuntu-20.04-server-base.json
    ```

6. Wait for the build to finish. End to end build of minimal Ubuntu Server box using the specified VM configuration takes around 25-30 minutes. The output is saved in `box/virtualbox/` folder and can be used with `vagrant box add` as described in [Vagrant CLI documentation](https://www.vagrantup.com/docs/cli/box.html#box-add).

## What else?

While the template and provisioning scripts have been tested through numerous builds, there is a little bit of hacking going on with various timings in the provisioning process to make Packer work with Ubuntu Server Live Installer. Watch this space - more detail and troubleshooting information to be provided soon. Check out 'Useful Resources' section below if you get stuck.

## Useful Resources

- [Packer Documentation](https://www.packer.io/docs/)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Ubuntu Wiki - Automated Server Installs](https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls)
- [Vagrant Documentation](https://www.vagrantup.com/docs/)
