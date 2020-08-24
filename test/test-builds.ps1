# Define script input parameter to capture test items to run
param([String[]] $tests)

# If no specific test items have been specified, run all test definitions
if ($tests.count -eq 0) {
    $tests = "ubuntu-base-vagrant","ubuntu-base-alt","lubuntu-vagrant","lubuntu-alt","lubuntu-vagrant-cloud"
}

### Test Build Definitions ###

function ubuntu-base-vagrant ($box) {
    packer build -force -var $("vm_name=$box") ubuntu-20.04-server-base.json > $("$PSScriptRoot\logs\$box.log")
}

function ubuntu-base-alt ($box) {
    packer build -force -var $("vm_name=$box") --var-file=auto-secret-overrides.json ubuntu-20.04-server-base.json > $("$PSScriptRoot\logs\$box.log")
}

function lubuntu-vagrant ($box) {
    packer build -force -var  $("vm_name=$box") -except=publish-vc lubuntu-20.04.json > $("$PSScriptRoot\logs\$box.log")
}

function lubuntu-alt ($box) {
    packer build -force -var $("vm_name=$box") -except=publish-vc --var-file=auto-secret-overrides.json lubuntu-20.04.json > $("$PSScriptRoot\logs\$box.log")
}

function lubuntu-vagrant-cloud ($box) {
    # This will only work if you have set a valid Vagrant Cloud token in $env:VC_TOKEN
    $vagrant_cloud_token = $("vagrant_cloud_token="+$env:VC_TOKEN)
    $vagrant_cloud_tag = "vagrant_cloud_tag=artislismanis/lubuntu-20.04"
    $vagrant_cloud_version = "vagrant_cloud_version=1.1.0"
    packer build -force -var $("vm_name=$box") -var $vagrant_cloud_token --var $vagrant_cloud_tag --var $vagrant_cloud_version lubuntu-20.04.json > $("$PSScriptRoot\logs\$box.log")
}

### Test Runner ###

# Clean up build logs from the previous run
Remove-Item $("$PSScriptRoot\logs\*.log")

# Run the specified test builds
foreach ($test in $tests) {
    Write-Host $("$test - start build")
    $("$test.ps1") >> $("$PSScriptRoot\logs\build-times.log")
    Measure-Command { 
        & (Get-ChildItem "Function:$test") $test
    } >> $("$PSScriptRoot\logs\build-times.log")
    vagrant box add --force --name ubuntu-base-vagrant $("$PSScriptRoot\..\box\virtualbox\$test\$test.box")
    Write-Host $("$test - end build")
}

