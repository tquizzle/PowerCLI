<# 
.SYNOPSIS   vSwitch & PortGroup Setup 
.DESCRIPTION   The following code will take you through copying all vSwitches and PortGroups from an existing ESX server over to a new server, ensuring they are exactly the same.
.NOTES  
.EXAMPLE  PS> ./vSwitchPGSetup.ps1
#>

$VISRV = Connect-VIServer (Read-Host "Please enter the name of your VI SERVER")
$BASEHost = Get-VMHost -Name (Read-Host "Please enter the name of your existing server as seen in the VI Client:")
$NEWHost = Get-VMHost -Name (Read-Host "Please enter the name of the server to configure as seen in the VI Client:")
 
$BASEHost |Get-VirtualSwitch |Foreach {
   If (($NEWHost |Get-VirtualSwitch -Name $_.Name-ErrorAction SilentlyContinue)-eq $null){
       Write-Host "Creating Virtual Switch $($_.Name)"
       $NewSwitch = $NEWHost |New-VirtualSwitch -Name $_.Name-NumPorts $_.NumPorts-Mtu $_.Mtu
       $vSwitch = $_
    }
   $_ |Get-VirtualPortGroup |Foreach {
       If (($NEWHost |Get-VirtualPortGroup -Name $_.Name-ErrorAction SilentlyContinue)-eq $null){
           Write-Host "Creating Portgroup $($_.Name)"
           $NewPortGroup = $NEWHost |Get-VirtualSwitch -Name $vSwitch |New-VirtualPortGroup -Name $_.Name-VLanId $_.VLanID
        }
    }
}