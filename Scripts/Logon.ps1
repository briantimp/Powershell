#Auto Run Citrix Application or Not
$autoRunApp = $true

#Remove User Profile on logoff
$removeUserProfile = $true

#Name of Citrix Application
$applicationName = "<Published App Name>"

#Allow script execution to take place
Set-ExecutionPolicy -ExecutionPolicy UnRestricted

#Get receiver to poll for application updates
Invoke-expression -Command:("C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\selfservice.exe -init -ipoll")

#Launch the published desktop
If ($autoRunApp) {
    Invoke-expression -Command:("C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfService.exe -qlaunch $applicationName")
}

#Wait for a citrix receiver session to launch aand then monitor until logoff is necessary
while (!(Get-Process wfica32 -ErrorAction SilentlyContinue)) {
    echo "Waiting for wfica32 to start"
    Start-Sleep -Seconds 5
}
while (Get-Process wfica32 -ErrorAction SilentlyContinue) {
    echo "Waiting for wfica32 to end"
    Start-Sleep -Seconds 5
}


If ($removeUserProfile) {
    #Get User SID for Registry Profile Tweak
    $userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $tempFolder = $env:TEMP

    #Write out a registry file to import the relevant settings, set the ProfileState to Temporary Profile
    "Windows Registry Editor Version 5.00" | Out-File -FilePath "$tempFolder\temp.reg"
    " " | Out-File -Append "$tempFolder\temp.reg"
    "[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$userSID]" | Out-File -Append "$tempFolder\temp.reg"
    """State""=dword:00000800" | Out-File -Append "$tempFolder\temp.reg"

    #Run regedit to silently import the reg file
    Invoke-expression -Command:("C:\Windows\Regedit.exe /s $tempFolder\temp.reg")
}

#Log the user off, because ProfileState is Temp it will get deleted
Invoke-expression -Command:("C:\Windows\System32\logoff.exe")
