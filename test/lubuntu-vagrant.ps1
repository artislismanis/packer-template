# Start script
Write-Host "lubuntu-vagrant - start"

# Clean up build log from the last run
if (Test-Path $($PSScriptRoot + "\logs\lubuntu-vagrant.log")) 
{
  Remove-Item $($PSScriptRoot + "\logs\lubuntu-vagrant.log")
}

# Run build
Measure-Command {  
  packer build -force -var 'vm_name=lubuntu-vagrant' -except=publish-vc lubuntu-20.04.json > $($PSScriptRoot + "\logs\lubuntu-vagrant.log")
} >>  $($PSScriptRoot + "\logs\build-times.log")

# End script
Write-Host "lubuntu-vagrant - end"