@{
    RootModule        = "PSEverything.psm1"
    ModuleVersion     = "0.1"
    Author            = "Lifailon"
    CompanyName       = "Open Source Community"
    Copyright         = "(c) 2024 Everything"
    Description       = "PowerShell wrapper for Everything. Instantly search for files on local and remote (via REST API) Windows systems."
    PowerShellVersion = "7.3"
    CmdletsToExport = "Find-Everything"
    AliasesToExport = "fe"
    PrivateData       = @{
        PSData = @{
            Tags = @("Everything", "Find", "Search", "API", "REST", "dotNET")
            ProjectUri = "https://github.com/Lifailon/PSEverything"
            LicenseUri = "https://github.com/Lifailon/PSEverything/blob/rsa/LICENCE"
            ReleaseNotes = "Getting data from local and remote computers via .NET library, REST API and ES (cli) for output in PSObject format. Enabling and disabling HTTP-server."
        }
    }
}