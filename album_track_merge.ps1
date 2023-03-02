# directory containing albums to join
param([string]$dir="Music") 

# function to go into folders recursively, join mp3 files in folder together and copy them to a directory
function intoFiles{
    # gets an array of folder names in the current directory
    [string[]] $folders = Get-ChildItem -Directory | Select-Object -ExpandProperty Name

    # if there are folders
    if (0 -ne $folders.Length){

        Foreach ($i in $folders){
            # add the current folder to the array of the path
            $global:paths = $global:paths + $i

            # go into folder
            Set-Location $i
            # reccur funtion
            intoFiles
            # leave folder
            Set-Location ..

            # remove the last folder from the path array to prevent repeated folders
            if (1 -eq $global:paths.Length){
                $global:paths = @()
            }else{
                $global:paths = $global:paths[0..($global:paths.Length-2)]
            }
        }
    # if there are no more folders
    }else{
        # create variables for the paths
        $levelsUp = "..\"
        $albumName = ""

        # create the paths
        For ($m=0; $m -le $global:paths.Length-1; $m++) {
            $levelsUp = $levelsUp + "..\"
            $albumName = $albumName +"-"+ $global:paths[$m]
        }

        $albumName = $albumName.TrimStart("-")
        $albumPath = $levelsUp + "Albums\"+ $albumName + ".mp3"
        $topFolder = $global:paths[0]
        $mp3InfoCommand = $levelsUp + 'mp3info -t "$albumName" -a "$topFolder" -l "$i" "$albumPath"'

        # get a list of the mp3 files in the current directory
        [string[]] $files = (Get-ChildItem *.mp3 -File | Select-Object -ExpandProperty Name)

        # change to escape ' in the file names
        For ($k=0; $k -le $files.Length-1; $k++) {
            $files[$k] = "file '"+$files[$k].replace("'","'\''")+"'"
        }
        # write filename to a file
        Write-Output $files | out-file songlist.txt -Encoding utf8NoBOM

        # join files and places them in a parent directory
        ffmpeg -f concat -safe 0 -i songlist.txt -c copy "$albumPath"
        # use mp3info to tag new files
        Invoke-Expression $mp3InfoCommand
        # remove song list file
        Remove-Item songlist.txt
    }
    
}

# create global variable for the file paths
$global:paths = @()

# create a directory to place the albums into and go into the music folder
if (Test-Path -Path "Albums") {
    Write-Output "Folder for Albums already exists"
} else {
    MKDIR Albums
}


if (Test-Path -Path $dir) {  # if folder containing music exists

    Set-Location $dir
    # run recursive function
    intoFiles
    # return to original directory
    Set-Location ..

} else {
    Write-Output "Cannot find folder containing music. Create one called 'Music' or specify the name of your folder in the command line using '-dir YOURDIR'"
}
