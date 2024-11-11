$msg = ""
$WMIFlag = ""
#$InstallDate = "NULL"
If (gci 'HKLM:\System\Setup\Source*' -ErrorAction SilentlyContinue)
{
# Reg key exists;
$reg = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\Setup\Source* | Select-Object -ExpandProperty InstallDate;
$reg = $reg | sort-object -descending | Select-Object -Last 1;
Foreach ($r in $reg){
[datetime]$origin = '1970-01-01 00:00:00';
$installdate = $origin.AddSeconds($r)
}
}
Else
{
# Reg key does not exist;
$InstallDate = ([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem).InstallDate)
}

# Check if the result is NULL. If so the registry part of the script failed.
If ($InstallDate -eq $null)
{
$WMIFlag = "YES"
# Cannot get original date from registry, using WMI instead
$InstallDate = ([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem).InstallDate)
}

# Check if the result is still NULL (Powershell failed)
If ($installdate -eq $NULL)
{
$installdate = systeminfo | find "Original Install Date"
$installdate

If ($installdate -match '\d{2}/\d{2}/\d{4}')
{
    $installdate = $matches[0]
}
else
{
    Write-Host "Line " $installdate "does not contain a date / time in the expected format."
}

$installdate

}

$msg = "{0:yyyy/MM/dd}" -f $installdate

# Write out the final result
Write-Host $msg
