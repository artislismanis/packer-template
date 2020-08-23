if (Test-Path $($PSScriptRoot + "\..\box\virtualbox\ubuntu-base-vagrant\ubuntu-base-vagrant.box")) 
{
    Write-Host "Attaching ubuntu-base-vagrant box to Vagrant"
    invoke-expression -Command $("vagrant box add --force --name ubuntu-base-vagrant "+$PSScriptRoot+"\..\box\virtualbox\ubuntu-base-vagrant\ubuntu-base-vagrant.box")
}

if (Test-Path $($PSScriptRoot + "\..\box\virtualbox\ubuntu-base-alt\ubuntu-base-alt.box")) 
{
    Write-Host "Attaching ubuntu-base-alt box to Vagrant"
    invoke-expression -Command $("vagrant box add --force --name ubuntu-base-alt "+$PSScriptRoot+"\..\box\virtualbox\ubuntu-base-alt\ubuntu-base-alt.box")
}

if (Test-Path $($PSScriptRoot + "\..\box\virtualbox\lubuntu-vagrant\lubuntu-vagrant.box")) 
{
    Write-Host "Attaching lubuntu-vagrant box to Vagrant"
    invoke-expression -Command $("vagrant box add --force --name lubuntu-vagrant "+$PSScriptRoot+"\..\box\virtualbox\lubuntu-vagrant\lubuntu-vagrant.box")
}

if (Test-Path $($PSScriptRoot + "\..\box\virtualbox\lubuntu-alt\lubuntu-alt.box")) 
{
    Write-Host "Attaching lubuntu-alt box to Vagrant"
    invoke-expression -Command $("vagrant box add --force --name lubuntu-alt "+$PSScriptRoot+"\..\box\virtualbox\lubuntu-alt\lubuntu-alt.box")
}

if (Test-Path $($PSScriptRoot + "\..\box\virtualbox\lubuntu-vagrant-cloud\lubuntu-vagrant-cloud.box")) 
{
    Write-Host "Attaching lubuntu-vagrant-cloud box to Vagrant"
    invoke-expression -Command $("vagrant box add --force --name lubuntu-vagrant-cloud "+$PSScriptRoot+"\..\box\virtualbox\lubuntu-vagrant-cloud\lubuntu-vagrant-cloud.box")
}

invoke-expression -Command "vagrant box list"

