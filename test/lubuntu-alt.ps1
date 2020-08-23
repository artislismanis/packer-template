# Start script
Write-Host "lubuntu-alt - start"

# Clean up build log from the last run
if (Test-Path $($PSScriptRoot + "\logs\lubuntu-alt.log")) 
{
  Remove-Item $($PSScriptRoot + "\logs\lubuntu-alt.log")
}

# Run build
Measure-Command {  
  packer build -force -var 'vm_name=lubuntu-alt' -except=publish-vc --var-file=auto-secret-overrides.json lubuntu-20.04.json > $($PSScriptRoot + "\logs\lubuntu-alt.log")
} >>  $($PSScriptRoot + "\logs\build-times.log")

# End script
Write-Host "lubuntu-alt - end"