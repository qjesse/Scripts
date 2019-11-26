#checks for path of our new CSV file and makes one if it's not there
Do {
    $pretest = 'C:\Users\' + $env:UserName + '\documents\output_users.csv'
    $pretest
    $testpath = Test-Path -Path $pretest
    if ($testpath -eq $true) {
        Write-Host "Success!"
        
    }
    elseif ($testpath -eq $false) {
        Write-Warning "Adding csv to path and checking again..."
        Add-Content -Path $pretest -Value "User Name,First Name,Last Name,Display Name,Job Title,Department,Office Number,Office Phone,Mobile Phone,Fax,Address,City,State or Province,ZIP or Postal Code,Country or Region"

        $testpath = $false
    }
    else {
        Write-Error "I don't know what happened. :("
    }
}While ($testpath -eq $false)




#--Use this array example to add users here--
<#
$users = 'example',
'example',
'example'
#>

#--Otherwise, use this CSV import (users must be first and last name in one cell seperated with a space)--
Write-Warning 'Users must be first and last name in one cell seperated with a space!'
$path = Read-Host -prompt "Please enter the FULL path of the CSV file (ex c:\users\jstandridge\documents\users.csv)"
$users = Import-CSV -Path $path -Header 'Users'

#generates the username (email) for our users, prompts user for domain entry
$domain = Read-Host -Prompt 'Please enter the domain for user(s)'

foreach ($user in $users) {
    $username = $user -Replace ' ', '.' -Replace "'", '' -replace '}', '' -Replace '@{users=', ''
    $first, $last = $user -split ' ' -replace '}', '' -Replace '@{users=', '' 
    $first =(Get-Culture).TextInfo.ToTitleCase($first.ToLower()) 
    $last = (Get-Culture).TextInfo.ToTitleCase($last.ToLower())
    $displayname = $user -replace '}', '' -Replace '@{users=', '' 
    $displayname = (Get-Culture).TextInfo.ToTitleCase($displayname.ToLower())
    $email = $username.ToLower() + '@' + $domain
    $employees = @(

        "$email,$first,$last,$displayName"

    )
    $employees | foreach-Object { Add-Content -Path  $pretest -Value $_ }
}


Write-Host "Done! Wrote new file in your documents folder in file output_users.csv. Any issues? Delete the file and try again, or contact Jesse."
Start-Sleep -seconds 5

<#
 $employees = foreach ($user in $users) { @(

  "$first,$last,$email,$displayName"

  )
  }
  #>


