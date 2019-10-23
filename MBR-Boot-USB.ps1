# Define Path to the Windows ISO
$ISOFile = "C:\Temp\WindowsServer2019.iso"
 
# Get the USB Drive you want to use, copy the friendly name
#Get-Disk | Where BusType -eq "USB"
 
# Get the right USB Drive (You will need to change the FriendlyName)
#$USBDrive = Get-Disk | Where FriendlyName -eq "Kingston DT Workspace"
$USBDrive = Get-Disk | Where-Object BusType -eq USB | Out-GridView -Title 'Select USB Drive to Format' -OutputMode Single |
Clear-Disk -RemoveData -RemoveData -Confirm:$false -PassThru | Initialize-Disk -PartitionStyle MBR 
 
# Create partition primary and format to NTFS
$Volume = $USBDrive | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel USBBOOTDISK
 
# Set Partiton to Active
$Volume | Get-Partition | Set-Partition -IsActive $true
 
# Mount ISO
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru
 
# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter
 
# Copy Files to USB
Copy-Item -Path ($ISODriveLetter +":\*") -Destination ($Volume.DriveLetter + ":\") -Recurse
 
# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile
