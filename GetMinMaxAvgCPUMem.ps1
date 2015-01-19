<# 
.SYNOPSIS   Get Min,Max and Average for CPU and Memory
.DESCRIPTION  
.NOTES  
.EXAMPLE      PS> ./GetMinMaxAvgCPUMem.ps1
.EXAMPLE      Disconnect-VIServer -Confirm:$false
#>
add-pssnapin VMware.VimAutomation.Core
Connect-VIServer -Server vcetner server IP or FQDN name
  $allvms = @()
  $vms = Get-Vm -Name *Coder*
  # on below entry one can specify start and finish time period by use AddHours or AddDays
  $stats = Get-Stat -Entity $vms -start (get-date).AddHours(-168) -Finish (Get-Date).AddHours(-159) -MaxSamples 10000 -stat "cpu.usage.average","mem.usage.average"
  $stats | Group-Object -Property Entity | %{
    $vmstat = "" | Select VmName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
    $vmstat.VmName = $_.name
    $cpu = $_.Group | where {$_.MetricId -eq "cpu.usage.average"} | Measure-Object -Property value -Average -Maximum -Minimum
    $mem = $_.Group | where {$_.MetricId -eq "mem.usage.average"} | Measure-Object -Property value -Average -Maximum -Minimum
    $vmstat.CPUMax = [int]$cpu.Maximum
    $vmstat.CPUAvg = [int]$cpu.Average
    $vmstat.CPUMin = [int]$cpu.Minimum
    $vmstat.MemMax = [int]$mem.Maximum
    $vmstat.MemAvg = [int]$mem.Average
    $vmstat.MemMin = [int]$mem.Minimum
    $allvms += $vmstat
  }
  $allvms | Select VmName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv "VM-Performance.xlsx" -noTypeInformation
  
