<# 
.SYNOPSIS   Create new vSwitches
.DESCRIPTION  
.NOTES  
I like to create my vSwitches w/ Powershell so I can name them accordingly. If created via the C# or Web Client, they are named vSwtich2 or something non-helpful.

#>


Get-VMHost | New-VirtualSwitch -Name "vSwitch Name Here"
Get-VMHost | Get-VirtualSwitch -Name "vSwitch Name Here" | New-VirtualPortGroup -Name "PortGroup Name Here"
