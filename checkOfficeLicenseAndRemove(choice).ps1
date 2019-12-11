#Requires -RunAsAdministrator


$x86_boopath = Test-Path -Path "${Env:ProgramFiles(x86)}\Microsoft Office\Office16\OSPP.VBS"
$regular_boopath = Test-Path -Path "${Env:ProgramFiles}\Microsoft Office\Office16\OSPP.VBS"

$path = $null

Write-Host "Checking common paths for OSPP.VBS..."

if ($x86_boopath -eq $true) {
    $path = "${Env:ProgramFiles(x86)}\Microsoft Office\Office16\OSPP.VBS"
    Write-Host "Path Program Files(x86) is valid. Wrote to path variable. Please wait..."
}
elseif ($regular_boopath -eq $true) {
    $path = "${Env:ProgramFiles}\Microsoft Office\Office16\OSPP.VBS"
    Write-Host "Path Program Files is valid. Wrote to path variable. Please wait..."
} else {
    Write-Host "Couldn't find Office install path. Closing..."
    Sleep-Start -seconds 5
    exit
}

$checkStatus = Invoke-Expression "cscript '$path' /dstatus"

Try {
    $checkStatus
}
Catch {
    Write-Error "An error has occured. Reference ID #4559"
}

#Starting Selection Screen
function Show-Menu {
    param (
        [string]$Title = 'Menu'
    )
    Write-Host "================ $Title ================"

    Write-Host "1: Press '1' to see / select which to delete."
    Write-Host "2: Press '2' to delete all keys."
    Write-Host "Q: Press 'Q' to quit."
}

Show-Menu

$selection = Read-Host
switch ($selection) {
    '1' {
        Do {
            $productKeyInput = Read-Host -Prompt "Which product key would you like to remove? (Must be 5 characters)"
            if ($productKeyInput.length -eq 5) {
                Write-Host "Attempting to remove $productKeyInput"
                continue
            } else {
                Write-Host "Invalid. Must be 5 characters." -BackgroundColor DarkRed
                $productKeyInput = $null
            }
            } While ($null -eq $productKeyInput)
            
            Write-Host "Please wait..."
            
            Do {
                Try {
                    $unpin = Invoke-Expression "cscript '$path' /unpkey:$productKeyInput"
                    if ($unpin -match '<Product key not found>') {
                        Write-Error -Message "There's either no more keys or we couldn't find that product key." -ErrorAction Stop    
                    } elseif ($unpin -match '<Product key uninstall successful>') {
                        Write-Host "Successfully unpined product key from Microsoft Office." -BackgroundColor DarkGreen
                        $success = $true
                        Write-Host "Task completed. Closing in 10 seconds."
                        Start-Sleep -seconds 10 
                        exit
                    }
                }
                Catch {
                    $answer = Read-Host -Prompt "Would you like to try a different key from the list? (y/n)"
                    if ($answer -eq 'y') {
                        Do {
                           $productKeyInput = Read-Host -Prompt "Which product key would you like to remove? (Must be 5 characters)"
                           if ($productKeyInput.length -eq 5) {
                            Write-Host "Attempting to remove $productKeyInput"
                            continue
                        } else {
                        Write-Host "Invalid. Must be 5 characters." -BackgroundColor DarkRed
                        $productKeyInput = $null
                        }
                        } While ($null -eq $productKeyInput)
            
                        $success = $null
                        } else {
                        exit
                    }
                } 
            } While ($null -eq $success)
    }
    '2' {
       Invoke-Expression "cscript '$path' /r"
    }
    'q' {
        exit
    }
}

