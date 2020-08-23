# Start script
Write-Host "ubuntu-base-vagrant - start"

# Clean up build log from the last run
if (Test-Path $($PSScriptRoot + "\logs\ubuntu-base-vagrant.log")) 
{
  Remove-Item $($PSScriptRoot + "\logs\ubuntu-base-vagrant.log")
}

# Run build
Measure-Command {  
  packer build -force -var 'vm_name=ubuntu-base-vagrant' ubuntu-20.04-server-base.json > $($PSScriptRoot + "\logs\ubuntu-base-vagrant.log")
} >>  $($PSScriptRoot + "\logs\build-times.log")

# End script
Write-Host "ubuntu-base-vagrant - end"
