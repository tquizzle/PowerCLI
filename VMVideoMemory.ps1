function Set-VMVideoMemory {
<# 
.SYNOPSIS   Changes the video memory of a VM 
.DESCRIPTION   This function changes the video memory of a VM 
.NOTES   Source: http://virtu-al.net   Author: Alan Renouf   Version: 1.1 
.PARAMETER VM   Specify the virtual machine 
.PARAMETER MemoryMB   Specify the memory size in MB 
.EXAMPLE  PS> Get-VM VM1 | Set-VMVideoMemory -MemoryMB 4 -AutoDetect $false
#>
 
  Param (
    [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter a vm entity")]
    [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl]$VM,
    [int64]$MemoryMB,
	[bool]$AutoDetect,
	[int]$NumDisplays
   )
 
  Process {
	$VM | Foreach {
		$VideoAdapter = $_.ExtensionData.Config.Hardware.Device | Where {$_.GetType().Name -eq "VirtualMachineVideoCard"}
		$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
		$Config = New-Object VMware.Vim.VirtualDeviceConfigSpec
		$Config.device = $VideoAdapter
		If ($MemoryMB) {
			$Config.device.videoRamSizeInKB = $MemoryMB * 1KB
		}
		If ($AutoDetect) {
			$Config.device.useAutoDetect = $true
		} Else {
			$Config.device.useAutoDetect = $false
		}
		Switch ($NumDisplays) {
			1{ $Config.device.numDisplays = 1}
			2{ $Config.device.numDisplays = 2}
			3{ $Config.device.numDisplays = 3}
			4{ $Config.device.numDisplays = 4}
			Default {}
		}
		$Config.operation = "edit"
		$spec.deviceChange += $Config
		$VMView = $_ | Get-View
		Write-Host "Setting Video Display for $($_)"
		$VMView.ReconfigVM($spec)
	}
  }
}
 
# For a single VM setting the video memory to 4MB
# Get-VM VIEW01 | Set-VMVideoMemory -MemoryMB 4 -AutoDetect $false
 
# For all VMs on a Host setting the vide memory to Auto Detect
# Get-VMHost Host01 | Get-VM | Set-VMVideoMemory -AutoDetect $true
 
# For all VMs in a cluster to set the Video Memory to 8MB
# Get-Cluster Production | Get-VM | Set-VMVideoMemory -MemoryMB 8 -AutoDetect $false