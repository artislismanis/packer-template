# Start script
Write-Host "ubuntu-base-alt - start"

# Clean up build log from the last run
if (Test-Path $($PSScriptRoot + "\logs\ubuntu-base-alt.log")) 
{
  Remove-Item $($PSScriptRoot + "\logs\ubuntu-base-alt.log")
}

# Run build
Measure-Command {  
  packer build -force -var 'vm_name=ubuntu-base-alt' --var-file=auto-secret-overrides.json ubuntu-20.04-server-base.json > $($PSScriptRoot + "\logs\ubuntu-base-alt.log")
} >>  $($PSScriptRoot + "\logs\build-times.log")

# End script
Write-Host "ubuntu-base-alt - end"