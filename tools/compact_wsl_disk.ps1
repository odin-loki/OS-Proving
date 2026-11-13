# compact_wsl_disk.ps1   Give the free space inside the WSL Ubuntu disk back to Windows (needs an elevated PowerShell: right-click > Run as administrator).
# Steps: shut WSL down (stops every WSL job; the proving run is resumable), compact ext4.vhdx offline with Optimize-VHD, report the size before and after.
# 13 Nov 2026: ext4.vhdx had grown to 520 GB and C: ran out of space (21 MB free), which made WSL fail with I/O errors.
$vhd = "C:\Users\odinl\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"
$before = (Get-Item $vhd).Length / 1GB
Write-Host ("before: {0:N1} GB, C: free {1:N1} GB" -f $before, ((Get-PSDrive C).Free / 1GB))
wsl --shutdown
Start-Sleep 10
Optimize-VHD -Path $vhd -Mode Full
$after = (Get-Item $vhd).Length / 1GB
Write-Host ("after:  {0:N1} GB, C: free {1:N1} GB (gave back {2:N1} GB)" -f $after, ((Get-PSDrive C).Free / 1GB), ($before - $after))
