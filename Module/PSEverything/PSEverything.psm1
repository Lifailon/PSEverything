function Find-Everything {
    <#
    .SYNOPSIS
    PowerShell wrapper for Everything.
    Instantly search for files on local and remote (via REST API) Windows systems.
    .DESCRIPTION
    Examples:
    Find-Everything ping.exe
    Find-Everything -HttpServerEnabled
    Find-Everything -HttpServerDisabled
    Find-Everything ping.exe -ComputerName localhost
    find-Everything ping.exe -ComputerName localhost -user every -password thing
    Find-Everything ping.exe -ES
    .LINK
    https://github.com/Lifailon/PSEverything
    https://github.com/dipique/everythingio
    https://voidtools.com
    #>
    param (
        $Search,
        $ComputerName,
        $Port = "80",
        $User,
        $Password,
        [switch]$HttpServerEnabled,
        [switch]$HttpServerDisabled,
        [switch]$ES
    )
    function ConvertFrom-Byte {
        param (
            $byte
        )
        if (($byte.Length -eq 0) -or ($byte -eq "-1")) {
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
    ### REST API
    if ($null -ne $ComputerName) {
        $url = "http://$($ComputerName):$($Port)/?search=$($Search)&path_column=1&size_column=1&date_modified_column=1&json=1"
        ### Authorization
        if ($user) {
            $SecureString = ConvertTo-SecureString $Password -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential($User, $SecureString)
            $results = $(Invoke-RestMethod -Credential $Credential -AllowUnencryptedAuthentication -Uri $url).results
        }
        else {
            $results = $(Invoke-RestMethod $url).results
        }
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
        $ModulePath = "$($env:PSModulePath.Split(";")[0])\PSEverything"
        ### Confinguration ini
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
        ### ES (command line interface)
        elseif ($ES) {
            $esExec = "$ModulePath\bin\es.exe"
            $testPath = Test-Path $esExec
            if ($testPath -eq $False) {
                Start-Job -Name ES -ScriptBlock {
                    $UrlDownload = "https://voidtools.com/ES-1.1.0.26.zip"
                    Invoke-RestMethod -Uri $UrlDownload -OutFile "$using:ModulePath\bin\es.zip"
                    Expand-Archive -Path "$using:ModulePath\bin\es.zip" -DestinationPath "$using:ModulePath\bin\"
                    Remove-Item -Path "$using:ModulePath\bin\es.zip"
                } | Out-Null
                $JobState = $(Get-Job -Name ES).State
                while ($JobState -eq "Running") {
                    $JobState = $(Get-Job -Name ES).State
                }
                Get-Job -Name ES | Remove-Job
            }
            $data = & $esExec -r $Search -name -size -date-modified -full-path-and-name -csv 
            $results = $data | ConvertFrom-CSV
            $format = "dd/MM/yyyy HH:mm"
            $culture = [System.Globalization.CultureInfo]::InvariantCulture
            $Collections = New-Object System.Collections.Generic.List[System.Object]
            foreach ($result in $results) {
                $Collections.Add([PSCustomObject]@{
                    name = $result.Name
                    size = ConvertFrom-Byte $result.size
                    date_modified = [DateTime]::ParseExact($result."Date Modified", $format, $culture)
                    path = $result.Filename
                })
            }
            $Collections
        }
        ### Everythingio (CSharp to .NET dll)
        ### dotnet build .\everythingio.csproj
        else {
            $EverythingDll = "$ModulePath\bin\everythingio.dll"
            Add-Type -Path $EverythingDll
            $results = [Everything]::Search($Search)
            $Collections = New-Object System.Collections.Generic.List[System.Object]
            foreach ($result in $results) {
                $Collections.Add([PSCustomObject]@{
                    name = $result.Filename
                    size = ConvertFrom-Byte $result.size
                    date_modified = [DateTime]$result.DateModified
                    path = $result.path
                })
            }
            $Collections
        }
    }
}