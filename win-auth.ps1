<#


Checks all the login and logoff RDP session history and creates a csv file in the folder 
where this script runs.

The report will contain, time of the activity, user name, action, IP from it was accessed. 

Run it in powershell & wait for it to automatically close, there will be *.csv file generated 
on the same folder where this script is run from. 


#>
$JumpVM = @('x.x.x.x')



$AdminPerson = "Administrator"
#$Pwd = "xxxx123!"

foreach ($Server in $JumpVM) {

    $Log = @{
        LogName = 'Microsoft-Windows-TerminalServices-LocalSessionManager/Operational'
        ID = 21, 23, 24, 25
        StartTime=(Get-Date).AddHours(-336)
        }

    $Collect = Get-WinEvent -FilterHashtable $Log -ComputerName $Server -Credential $Server\$AdminPerson 
    $lines = $Collect.count
    If($lines -eq 0){ 
    echo "There are no RDP connections to this server "
    echo ""
    }
    Else {
    echo "The number of activities on this server are : ${lines}"
    echo ""
    }

    $Collect | Foreach { 
           $detail = [xml]$_.ToXml()
        [array]$Output += New-Object PSObject -Property @{
            TimeCreated = $_.TimeCreated
            User = $detail.Event.UserData.EventXML.User
            IPAddress = $detail.Event.UserData.EventXML.Address
            EventID = $detail.Event.System.EventID
            ServerName = $Server
            }        
           } 
}

$Result += $Output | Select TimeCreated, User, ServerName, IPAddress, @{Name='Action';Expression={
            if ($_.EventID -eq '21'){"logon"}
            if ($_.EventID -eq '22'){"Shell start"}
            if ($_.EventID -eq '23'){"logoff"}
            if ($_.EventID -eq '24'){"disconnected"}
            if ($_.EventID -eq '25'){"reconnection"}
            }
        }

$Date = (Get-Date -Format s) -replace ":", "."
$Result | Sort TimeCreated | Export-Csv $env:USERPROFILE\Desktop\$Date`_RDP_Report`.csv -NoTypeInformation

If ($lines -eq 0)
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
Else {
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}

#End
