Remove-Item .\build\FileDeleterTasker.exe
Invoke-ps2exe -inputFile ".\src\FileDeleterTasker.ps1" -outputFile ".\build\FileDeleterTasker.exe" -iconFile ".\images\icon.ico" -STA -noConsole -title 'FileDeleterTasker' -description 'Menage files to delete' -company 'PROPARK' -version '1.0.2'