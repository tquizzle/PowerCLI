<#
.EXAMPLE
   ./DiskIOStats.ps1
#>
$vm = (Read-Host " What VM would you like to view Disk I/O Stats on? ").ToUpper()

$metrics = "disk.numberwrite.summation","disk.numberread.summation"
$start = (Get-Date).AddMinutes(-5)
$report = @()
 
$vms = Get-VM -Name $vm | where {$_.PowerState -eq "PoweredOn"}
$stats = Get-Stat -Realtime -Stat $metrics -Entity $vms -Start $start
$interval = $stats[0].IntervalSecs
 
$lunTab = @{}
foreach($ds in (Get-Datastore -VM $vms | where {$_.Type -eq "VMFS"})){
  $ds.ExtensionData.Info.Vmfs.Extent | %{
    $lunTab[$_.DiskName] = $ds.Name
  }
}
 
$report = $stats | Group-Object -Property {$_.Entity.Name},Instance | %{
  New-Object PSObject -Property @{
    VM = $_.Values[0]
    Disk = $_.Values[1]
    IOPSMax = ($_.Group | `
      Group-Object -Property Timestamp | `
      %{$_.Group[0].Value + $_.Group[1].Value} | `
      Measure-Object -Maximum).Maximum / $interval
    Datastore = $lunTab[$_.Values[1]]
  }
}
 
$report
