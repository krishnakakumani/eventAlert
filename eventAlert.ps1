#Get-WinEvent -FilterHashtable @{LogName='System';StartTime=(Get-Date).AddMinutes(-60)} | Where-Object -FilterScript {$_.ProviderName -eq 'Microsoft-Windows-Time-Service' -and $_.Id -eq 35} |  Select-Object -First 1

#$Alert = Get-WinEvent -FilterHashtable @{LogName='System';StartTime=(Get-Date).AddMinutes(-10)} | Where-Object -FilterScript {$_.ProviderName -eq 'Microsoft-Windows-WindowsUpdateClient' -and $_.Id -eq 44} |  Select-Object -First 1
$Alert= echo System | % { get-winevent $_ -maxevents 100 } | Where-Object -FilterScript {$_.ProviderName -eq 'Microsoft-Windows-WindowsUpdateClient' -and $_.Id -eq 43}|  Select-Object -First 1

$mailbody = "Event ID: "+ $Alert.Id + "`nEvent ProviderName: "+ $Alert.ProviderName + "`nEvent Message: "+ $Alert.Message +  "`nEvent TimeCreated: "+ $Alert.TimeCreated

$previousExecutionTime= Get-Content D:\eventAlert\previous_time.txt | Select-Object -Last 2 | Out-String
$previousExecutionTimeDateTime = Get-Date $previousExecutionTime
$pde = $previousExecutionTimeDateTime.ToString("yyyy-MM-ddTHH:mm:ss")


echo "Cuurent occurance: " $Alert.TimeCreated
echo "Old occurance: " $previousExecutionTime
$cde = $Alert.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ss")
#$pde = $previousExecutionTimeDateTime.ToString("yyyy-MM-ddTHH:mm:ss")

echo "Cuurent occurance: " $cde
echo "Old occurance: " $pde

if ( $cde -eq $pde ) {
	
}
else {

$EmailTo = "xxxx@gmail.com"  
      $EmailFrom = "xxxx@gmail.com"  
      $Subject = "Alert from $env:computername"  
      $Body = $mailbody
      $SMTPServer = "smtp.gmail.com"   
      $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom, $EmailTo, $Subject, $Body)
      $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
      $SMTPClient.EnableSsl = $true 
      $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("xxxx@gmail.com", "xxxx xxxx xxxx xxxx"); 
      $SMTPClient.Send($SMTPMessage)

}
$Alert.TimeCreated >> D:\eventAlert\previous_time.txt
 