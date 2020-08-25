# List of test definitions, needs to align with what's defined as test build to do full cleanup
if ($tests.count -eq 0) {
    $tests = "ubuntu-base-vagrant","ubuntu-base-alt","lubuntu-vagrant","lubuntu-alt","lubuntu-vagrant-cloud"
}

# Remove Vagrant box registrations & Packer box files
foreach ($test in $tests) {
    vagrant box remove $test
    if (Test-Path $("$PSScriptRoot\..\box\virtualbox\$test")) {
        Remove-Item -Recurse -Force $("$PSScriptRoot\..\box\virtualbox\$test")
    }
}