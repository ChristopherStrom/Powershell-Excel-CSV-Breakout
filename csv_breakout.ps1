
<# Break Out c:\Breakout\filename.csv by a group column "FieldName"  #>

  Import-Csv "c:\Breakout\filename.csv" | Group-Object -Property "FieldName" | 
    Foreach-Object {$path=$_.name+".csv" ; $_.group | 
    Export-Csv -Path $path -NoTypeInformation}
    
    
<# List out number of items per each field group #>
Get-ChildItem "C:\Breakout" -re -in "*.csv" |
    ForEach-Object {
        $fileStat = Get-Content $_.FullName | Measure-Object -Line
        $namef = $_.FullName
        $linesInFile = $fileStat.Lines -1
        Write-Host "$($namef) , $($linesInFile)"
        }

        Add-Type -AssemblyName System.Collections

function Split-Csv {

    param (
        [string]$filePath,
        [int]$partsNum
    )

    # Use generic lists for import/export
    [System.Collections.Generic.List[object]]$contentImport = @()
    [System.Collections.Generic.List[object]]$contentExport = @()

    # import csv-file
    $contentImport = Import-Csv $filePath

    # how many lines per export file
    $linesPerFile = [Math]::Max( [int]($contentImport.Count / $partsNum), 1 )
    # start pointer for source list
    $startPointer = 0
    # counter for file name
    $counter      = 1

    # main loop
    while( $startPointer -lt $contentImport.Count ) {
        # clear export list
        [void]$contentExport.Clear()
        # determine from-to from source list to export
        $endPointer = [Math]::Min( $startPointer + $linesPerFile, $contentImport.Count )
        # move lines to export to export list
        [void]$contentExport.AddRange( $contentImport.GetRange( $startPointer, $endPointer - $startPointer ) )
        # export
        $contentExport | Export-Csv -Path ($filePath.Replace('.', $counter.ToString() + '.' ) ) -NoTypeInformation -Force
        # move pointer
        $startPointer = $endPointer
        # increase counter for filename
        $counter++
    }

}

<# Split selected .csv into multiple parts #>

## Used to split data up into muliple files.  Good for importing into systems that have maximum size limits
#Split-Csv -filePath 'FileName.csv' -partsNum 1


 