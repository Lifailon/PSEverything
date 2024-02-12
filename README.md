# PSEverything

PowerShell wrapper for [Everything](https://www.voidtools.com). Instantly search for files on local and remote Windows systems for output in PSObject format.

3 ways of data retrieval are implemented:

- ✅ Remote via REST API
- ✅ Locally via .NET library
- ✅ Locally via ES (Command-line Interface)

## 🚀 Install

You need to [install the Everything](https://www.voidtools.com/downloads) program (a portable version is present) and wait for the local database to be indexed after the first run.

Use the [NuGet](https://www.nuget.org/packages/ps.win.api) package manager:

```PowerShell
Install-Module PSEverything -Repository NuGet -AllowClobber
```

💡 You must have a NuGet repository registered:

```PowerShell
Register-PSRepository -Name "NuGet" -SourceLocation "https://www.nuget.org/api/v2" -InstallationPolicy Trusted
```

When using PSEverything module for the first time, be sure to start Everything to save the path to the executable process in the configuration file. This is necessary for those cases when you do not have Everything configured to start automatically after a system reboot or the process has terminated for some reason.

## 🔍 Examples

Local computer:

```PowerShell
> Find-Everything pingui

name                     size      date_modified       path
----                     ----      -------------       ----
PingUI                   folder    12.02.2024 13:37:24 C:\Users\lifailon\Documents\Git\PingUI
PingUI                   folder    16.10.2023 16:20:28 D:\Drive-10-2023\Scripts\Python\PingUI
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 22.05.2023 17:12:00 C:\Users\lifailon\Documents\Git\PingUI\Image\PingUI-0.1-Fast-Mode.jpg
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 21.05.2023 0:14:49  D:\Drive-10-2023\Scripts\Python\PingUI\Image\PingUI-0.1-Fast-Mode.jpg
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 22.05.2023 17:12:20 C:\Users\lifailon\Documents\Git\PingUI\Image\PingUI-0.1-Slow-Mode.jpg
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 21.05.2023 0:15:39  D:\Drive-10-2023\Scripts\Python\PingUI\Image\PingUI-0.1-Slow-Mode.jpg
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:26  C:\Users\lifailon\Documents\Git\PingUI\Source\PingUI-0.1.py
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:21  D:\Drive-10-2023\Scripts\Python\PingUI\Source\PingUI-0.1.py
PingUI-0.2.jpg           734,53 Kb 23.05.2023 10:54:03 C:\Users\lifailon\Documents\Git\PingUI\Image\PingUI-0.2.jpg
PingUI-0.2.jpg           734,53 Kb 23.05.2023 10:53:55 D:\Drive-10-2023\Scripts\Python\PingUI\Image\PingUI-0.2.jpg
PingUI-0.2.py            10,18 Kb  23.05.2023 9:43:59  C:\Users\lifailon\Documents\Git\PingUI\Source\PingUI-0.2.py
PingUI-0.2.py            10,18 Kb  23.05.2023 9:43:53  D:\Drive-10-2023\Scripts\Python\PingUI\Source\PingUI-0.2.py
pingui-test-file.txt     7         11.02.2024 16:15:49 C:\Users\lifailon\Documents\pingui-test-file.txt
pingui-test-file.txt.lnk 688       11.02.2024 16:15:44 C:\Users\lifailon\AppData\Roaming\Microsoft\Windows\Recent\pingui-test-file.txt.lnk

> Find-Everything pingui-0.1.py | Format-List

name          : PingUI-0.1.py
size          : 10,15 Kb
date_modified : 21.05.2023 1:23:26
path          : C:\Users\lifailon\Documents\Git\PingUI\Source\PingUI-0.1.py

name          : PingUI-0.1.py
size          : 10,15 Kb
date_modified : 21.05.2023 1:23:21
path          : D:\Drive-10-2023\Scripts\Python\PingUI\Source\PingUI-0.1.py
```

💡 The first time you use the cli version (`ES` parameter), you must wait until the dependency files (`es.exe` and `es.c`) are automatically installed.

```PowerShell
> Find-Everything pingui-0.1 -es

name                     size      date_modified       path
----                     ----      -------------       ----
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 22.05.2023 17:12:00 C:\Users\lifailon\Documents\Git\PingUI\Image\PingUI-0.1-Fast-Mode.jpg
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 21.05.2023 0:14:00  D:\Drive-10-2023\Scripts\Python\PingUI\Image\PingUI-0.1-Fast-Mode.jpg
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 22.05.2023 17:12:00 C:\Users\lifailon\Documents\Git\PingUI\Image\PingUI-0.1-Slow-Mode.jpg
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 21.05.2023 0:15:00  D:\Drive-10-2023\Scripts\Python\PingUI\Image\PingUI-0.1-Slow-Mode.jpg
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:00  C:\Users\lifailon\Documents\Git\PingUI\Source\PingUI-0.1.py
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:00  D:\Drive-10-2023\Scripts\Python\PingUI\Source\PingUI-0.1.py
```

Remote computer:

```PowerShell

> Find-Everything pingui-0.1 -ComputerName localhost
Invoke-RestMethod: 401 Unauthorized401 Unauthorize

> Find-Everything pingui-0.1 -ComputerName localhost -User every -Password thing

name                     size      date_modified       path
----                     ----      -------------       ----
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 22.05.2023 17:12:00 C:\Users\lifailon\Documents\Git\PingUI\Image
PingUI-0.1-Fast-Mode.jpg 296,23 Kb 21.05.2023 0:14:49  D:\Drive-10-2023\Scripts\Python\PingUI\Image
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 22.05.2023 17:12:20 C:\Users\lifailon\Documents\Git\PingUI\Image
PingUI-0.1-Slow-Mode.jpg 329,45 Kb 21.05.2023 0:15:39  D:\Drive-10-2023\Scripts\Python\PingUI\Image
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:26  C:\Users\lifailon\Documents\Git\PingUI\Source
PingUI-0.1.py            10,15 Kb  21.05.2023 1:23:21  D:\Drive-10-2023\Scripts\Python\PingUI\Source
```

[License](https://github.com/Lifailon/PSEverything/blob/rsa/LICENCE)