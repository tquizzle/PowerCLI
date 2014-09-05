Get-VM -Name <vmNamesHere> | Get-View | ForEach-Object {
  Write-Output $_.name
  if ($_.config.tools.toolsUpgradePolicy -ne "manual"){
    $vm = Get-VM -Name $_.name
    $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $spec.tools = New-Object VMware.Vim.ToolsConfigInfo
    $spec.tools.toolsUpgradePolicy = "manual"
    $_this = Get-View -Id $vm.Id
    $_this.ReconfigVM_Task($spec)
    Write-Output "Completed"
  }
}
