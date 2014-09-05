# Reconfigure-VMHostHA.ps1
# PowerCLI script to reconfigure for VMware HA a VM Host
# Usage: ./Reconfigure-VMHostHA.ps1 <hostname>
 
param([string]$esx)

if (-not $esx) {
  Write-Host "No ESXi Host defined as input"
  Break
} else {
  $vmhost = Get-VMHost $esx
  $esxha = Get-View $vmhost.Id
  $esxha.ReconfigureHostForDAS()
  Write-Host "Reconfigured Host" $vmhost "for HA"
}
