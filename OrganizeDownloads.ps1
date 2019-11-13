# This script is used to organize the Downloads Folder of the User who runs this script. 
# All files will be sorted by extension. If the file already exists in the extension folder then the file will be overwritten with the file with the newest write time
# Created by Nickalas Porsch

Write-Host "Organizing Downloads Folder"
$user = $env:Username
$path = "C:\Users\" + $user + "\Downloads\"
Get-ChildItem -Path ($path + "*") -File | 
    ForEach-Object{
       # The below line lists all the methods an properties of each the object given to it.
       #Get-Member -InputObject $_
       $ifItemRemoved = $false
       #turns the extension as a string
       $ext = $_.Extension.ToString()
       #removes the period from the extension

       $ext = $ext.Substring(1)
       $loc =  -join($path ,$ext.ToString())

       #Checks to see if the folder exists in the Download folder
       if(-not (Test-Path $loc)){
           New-Item -ItemType directory -Path $loc
        }

        #Sees if the file already exists in the extension folder folder
        $testPath = (-join($loc, -join( "\",$_.Name)))
       if(Test-Path -Path $testPath){


            $old = Get-ChildItem (-join($loc, -join( "\",$_.Name))) -File
            $lastWriteTime = $_.LastWriteTime
            $oLWT = $old.LastWriteTime

            #Compares to see which of the two were last written to and then replaces the old item.
            if($lastWriteTime -gt $oLWT){
                Remove-Item (-join($loc, -join( "\",$_.Name)))
            }
            else{
                Remove-Item -Path $_.FullName
                $ifItemRemoved = $true
            }
       }
       if($ifItemRemoved -eq $false){
            Move-Item -Path $_.FullName $loc
        }
    }