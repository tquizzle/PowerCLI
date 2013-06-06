<#
.TITLE
		View VM Mac Addresses

.SYNOPSIS
    Retrieves the MAC addresses of virtual machines on a vSphere server.
 
  .DESCRIPTION
    Retrieves the MAC addresses of virtual machines on a vSphere server.
    In addition it retrieves also the IP addresses and the connection state.
 
  .PARAMETER VM
    Specify virtual machines whose MAC addresses you want to retrieve.
 
  .EXAMPLE
    Get-VmMacAddress
    Retrieves the MAC addresses of all the virtual machines.
 
  .EXAMPLE
    Get-VmMacAddress -VM VM0123,VM0456
    Retrieves the MAC addresses of the virtual machines named VM01234 and VM0456.
 
  .EXAMPLE
    "VM0123","VM0456" | Get-VmMacAddress
    Retrieves the MAC addresses of the virtual machines named VM01234 and VM0456.
 
  .COMPONENT
    VMware vSphere PowerCLI
 
  .NOTES
    Author:  Robert van den Nieuwendijk
    Date:    12-09-2011
    Version: 1.0

#>
 
function Get-VmMacAddress {

  [CmdletBinding()]
  param(
    [parameter(ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true)]
               [string[]] [ValidateNotNull()] $VM=".*"
  )
 
  process {
    ForEach ($VirtualMachine in $VM) {
      # Get the virtual machine
      $VMsView = Get-View -ViewType VirtualMachine -Property Name,Guest.Net -Filter @{"Name"="$VirtualMachine$"}
      if ($VMsView) {
        $VMsView | `
          ForEach-Object {
            $VMview = $_
            $VMView.Guest.Net | `
              Select-Object -property @{N="VM";E={$VMView.Name}},
                MacAddress,
                IpAddress,
                Connected
          }
      }
    }
  }
}
