@echo off
color 0a 

type run.txt
echo. 
echo. 
@echo off
echo 1. Install Required Module 
echo 2. Convert ps1 to exe

set /p input1="Enter your choice: "

if "%input1%"=="1" (
  echo Installing Required Modules... Please Wait...
  REM Install ps2exe module from PowerShell Gallery
  powershell -ExecutionPolicy Bypass -Command "Install-Module -Name ps2exe -Scope CurrentUser"

  REM Check if installation was successful
  if %errorlevel% equ 0 (
    echo Installation successful.
  ) else (
    echo Installation failed.
  )
) else if "%input1%"=="2" (
  set /p input_file="Enter input_file name: "
  set /p output_file="Enter output_file name: "
  REM Convert the PowerShell script to executable using ps2exe
  powershell -ExecutionPolicy Bypass -Command "Import-Module ps2exe; ps2exe.ps1 -inputFile '%input_file%' -outputFile '%output_file%' -lcid 1033 -noConsole -ErrorAction SilentlyContinue"

  REM Check if conversion was successful
  if %errorlevel% equ 0 (
    echo Conversion successful.
  ) else (
    echo Conversion failed.
  )
) else (
  echo Invalid choice.
)

