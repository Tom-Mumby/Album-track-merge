# Album-Track-Merge
A PowerShell 7 script which recursively searches a music library to find album tracks at the bottom of the folder structure. It then uses [FFmpeg](https://ffmpeg.org/download) to merge them into one mp3 file for each album.

The music library is not changed and the album mp3 files are added to a new folder and tagged using [mp3info](https://ibiblio.org/mp3info/).

## Prerequisites
[FFmpeg](https://ffmpeg.org/download) and [mp3info](https://ibiblio.org/mp3info/) are needed to run the script. For Windows systems, they can be downloaded from the links above and then added to the system PATH before running.

## Usage 
To use, run from the parent folder of your music library. The name of the folder containing the library defaults to "Music" but can be changed when running using "-dir YOURDIR". 

On running, a folder called "Albums" is created which the merged album tracks will be added to.
