#Requires -modules MSOnline, AzureAD

#Make sure script doesn't continue if closed out of the initial Microsoft sign-in screen.
$error.clear()
Try {
    Connect-AzureAD
}
Catch {
    Write-Error "Requires sign-in to AzureAD. Exiting."
    exit
} 
$newPass = $null


#Get and check Email
Do {
    #Get Email from User
    $email = Read-Host 'Please type email of user (ex. john.smith@example.com) '

    Try {
        #Check if it's in AzureAD
        Get-AzureADUser -ObjectID $email -ErrorAction Stop | Out-Null
    }
    Catch {
        #Couldn't find the email in AzureAD
        Write-Warning -Message "Could not find a user with the email $email. Please try your search again."

        #Loop Back
        $email = $null
    }
}
While ($null -eq $email)



#Obtaining info
$getUser = Get-AzureADUser -ObjectId "$email" | Select-Object displayName
$userName = $getUser.displayName
Write-Host "User $userName has been loaded successfully. Proceed with caution. Continuing in 3 seconds."
Start-Sleep -seconds 3

#Do loop through the rest of the code to loop back around to this point when user input wants to.
Do {
    #Starting Selection Screen
    function Show-Menu {
        param (
            [string]$Title = 'Edit AzureAD User Information'
        )
        Write-Host "================ $Title ================"
    
        Write-Host "1: Press '1' to set new password."
        Write-Host "2: Press '2' to set new phone extension."
        Write-Host "3: Press '3' to set job title."
        Write-Host "Q: Press 'Q' to quit."
    }

    Show-Menu
    Write-Host 'Choose wisely, noble knight.'

    #Make selection, contains different functions for each selection
    $selection = Read-Host
    switch ($selection) {
        '1' {
            Write-Host 'Option 1: Set new password for' $userName
            function New-Password {
                Do {
                    "Enter new password:"
                    $newPass = Read-Host -AsSecureString
                    Write-Host "Password has successfully been encrypted."
                    if ($null -ne $newPass) {
                        Write-Host "Setting password..."
                        break
                    }
                    elseif ($null -eq $newPass) {
                        Write-Warning -Message "Invalid password entry. Try again."
                    }
    
                } While ($null -eq $newPass)

                $error.clear()
                Do {
                    Try {
                        Set-AzureADUserPassword -ObjectID $email -Password $newPass -ForceChangePasswordNextLogin $true
                    }
                    Catch {
                        Write-Host "An Error Has Occured. Required: Password that is at least 8 to 64 characters. It requires 3 out of 4 of: lowercase, uppercase, numbers, or symbols." -BackgroundColor DarkRed   
                    } if (!$error) {
                        $success = $true
                        Write-Host "Password successfully updated. User will reset password once logged on." -BackgroundColor Green
                    }
                } while ($success -ne $true)
            }
     
            New-Password

        } '2' {
            Write-Host 'Set extension for' $userName
            $ext = $null
            Do {
                $ext = Read-Host -prompt "Please enter ext(####)"
                if ($ext.length -eq 4) {
                    Set-AzureADUser -ObjectID $email -TelephoneNumber $ext
                    Write-Host "$userName ext updated successfully to $ext" -BackgroundColor Green
                    $success = $true
                }
                else {
                    Write-Host "Ext needs to be exactly 4 characters." -BackgroundColor Red
                    Write-Host $ext
                    $ext = $null
                    Write-Host $ext
                    $success = $false
                }
            } Until ($success -eq $true)
 
        } '3' {
            Write-Host 'Set job title for' $userName
            Do {
                $jobTitle = Read-Host -prompt "Please enter Job Title"
                if ($jobtitle.length -gt 1) {
                    Set-AzureADUser -ObjectID $email -JobTitle $jobTitle
                    Write-Host "$userName job title successfully set to $jobTitle" -BackgroundColor Green
                    $success = $true
                }
                elseif ($jobTitle.length -eq 0) {
                    Write-Host "Please enter job title." -BackgroundColor Red 
                    $success = $false
                }
                elseif ($jobTitle -match '[^a-zA-Z0-9]') {
                    Write-Host 'No special characters, please.' -BackgroundColor DarkYellow
                }
                else {
                    Write-Host "??????????????????==One character? What kind of job title is that?==??????????????????????"
                }
            } Until ($success -eq $true)

        } 'q' {
            return
        }
    }

    Write-Host "Would you like to do more? y/n/exit"
    $answer = Read-Host

} Until ($answer -eq 'exit' -or
         $answer -eq 'n')