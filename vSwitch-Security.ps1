<#
.SYNOPSIS   View your vSwitch Security Options
.DESCRIPTION  
.NOTES  This script exports the values to a CSV file so you can sort/filter to view all associated security settings
.NOTES   with the vSwitches on your ESXi hosts.
#>

Get-VirtualSwitch -Standard | Select VMHost, Name, @{N="PromiscuousMode";E={if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject"} }}, @{N="MacChanges";E={if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject"} }}, @{N="ForgedTransmits";E={if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject"} }} | Export-Csv ./vSwitch-Security.csv
