@{
    RootModule        = "PSEverything.psm1"
    ModuleVersion     = "0.1"
    Author            = "Lifailon"
    CompanyName       = "Open Source Community"
    Copyright         = "(c) 2024 Everything"
    Description       = "PowerShell wrapper for Everything. Instantly search for files on local and remote (via REST API) Windows systems."
    PowerShellVersion = "7.2"
    CompatiblePSEditions = "Desktop", "Core"
    CmdletsToExport = "Find-Everything"
    AliasesToExport = "fe"
    PrivateData       = @{
        PSData = @{
            Tags = @("Everything", "Find", "Search")
            ProjectUri   = "https://github.com/Lifailon/PSEverything"
            LicenseUri = "https://www.voidtools.com/License.txt"
            ReleaseNotes = "Getting data from local and remote computers via REST API in PSObject format. Enabling and disabling HTTP-server."
        }
    }
}