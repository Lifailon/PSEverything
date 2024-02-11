function Find-Everything {
    param (
        $Search,
        $ComputerName,
        $Port = "80",
        [switch]$HttpServerEnabled,
        [switch]$HttpServerDisabled,
        [switch]$Json
    )
    $esPathExec = "$home\Documents\ES-1.1.0.26\es.exe"
    function ConvertFrom-Byte {
        param (
            $byte
        )
        if ($byte.Length -eq 0) {
            $size = "folder"
        }
        elseif ([int64]$byte -ge 1gb) {
            $size = $($byte / 1gb).ToString("0.00 Gb")
        }
        elseif ([int64]$byte -ge 1mb) {
            $size = $($byte / 1mb).ToString("0.00 Mb")
        }
        elseif ([int64]$byte -ge 1kb) {
            $size = $($byte / 1kb).ToString("0.00 Kb")
        }
        else {
            $size = $byte
        }
        return $size
    }
    if ($null -ne $ComputerName) {
        $url = "http://$($ComputerName):$($Port)/?search=$($Search)&path_column=1&size_column=1&date_modified_column=1&json=1"
        $results = $(Invoke-RestMethod $url).results
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($result in $results) {
            $Collections.Add([PSCustomObject]@{
                name = $result.name
                size = ConvertFrom-Byte $result.size
                date_modified = [DateTime]::FromFileTime($result.date_modified)
                path = $result.path
            })
        }
        $Collections
    }
    else {
        if (($HttpServerEnabled) -or ($HttpServerDisabled)) {
            $process = Get-Process Everything -ErrorAction Ignore
            $EverythingExec = $process.Path
            Get-Process -id $process.id | Stop-Process -ErrorAction Ignore
            $EverythingPath = [System.IO.Path]::GetDirectoryName($EverythingExec).Trim()
            $iniPath = "$EverythingPath\Everything.ini"
            $ini = Get-Content $iniPath
            if ($HttpServerEnabled) {
                $ini = $ini -replace "http_server_enabled=.","http_server_enabled=1"
                $ini = $ini -replace "http_server_port=.+","http_server_port=$port"
            }
            elseif ($HttpServerDisabled) {
                $ini = $ini -replace "http_server_enabled=.","http_server_enabled=0"
            }
            $ini | Out-File $iniPath
            $process = Start-Process "$EverythingPath\Everything.exe" -ArgumentList "-close" -PassThru
            #while ($true) {
            #    if ($process.MainWindowHandle -ne 0) {
            #        break
            #    }
            #}
            #$process.CloseMainWindow()
        }
        else {
            $data = & $esPathExec -r $Search -name -size -date-modified -full-path-and-name -csv 
            if ($Json) {
                $data | ConvertFrom-CSV | ConvertTo-Json
            }
            else {
                $data | ConvertFrom-CSV
            }
        }
    }
}

# Find-Everything -HttpServerEnabled
# Find-Everything -HttpServerDisabled
# Find-Everything pingui
# Find-Everything pingui -ComputerName localhost
# Find-Everything pingui -ComputerName localhost -Json