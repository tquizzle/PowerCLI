<#
.AUTHOR
   Travis Quinnelly
.SYNOPSIS
   Bulk Storage vMotion -TQ
.DESCRIPTION
   Bulk Storage vMotion - Script will prompt for required data
.EXAMPLE
   ./BulkStoragevMotion.ps1
#>

#Import Plugins and Connect to vCenter

# Add the VI-Snapin if it isn't loaded already
if ( (Get-PSSnapin -Name "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null )
	{
		Add-PSSnapin -Name "VMware.VimAutomation.Core"
	}
$viserver = Read-Host "vCenter Server:"
Connect-VIServer -Server $viserver.ToUpper()

#Get all config info needed
Write-Host ""
		$source = (Read-Host " What datastore do you want to migrate?").ToUpper()
		$vms = Get-Datastore -Name $source | Get-VM

Write-Host ""
$which = (Read-Host " Bulk Storage vMotion to Datastore (C)luster or simple (D)atastore?").ToLower()
Write-Host ""
if ($which -eq "c")
	{
		$destination = (Read-Host " What Datastore Cluster do you want to migrate to?").ToUpper()
		$destination = Get-DatastoreCluster -Name $destination
	}
else
	{
		$destination = (Read-Host " What datastore do you want to migrate to?").ToUpper()
	}

Write-Host ""

#Storage vMotion each VM to selected cluster/datastore in a staged fashion 1 by 1
foreach($vm in $vms)
{
	#Storage vMotion of VM to the datastore of choice and wait to start next transfer
	Write-Host "  Executing SVMotion of" $vm.Name "from" $source "to" $destination "..."
	Write-Host "   Start Time:" (Get-Date)
	$task = Get-VM $vm.Name | Move-VM -Datastore $destination
	Write-Host "     End Time:" (Get-Date)
	Write-Host ""
}
#Disconnect and clear variables
#Disconnect-VIServer -Confirm $true
Clear-Variable -Name which,source,v*,dest*
