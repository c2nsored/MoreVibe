# MoreVibe Installer UI

This folder contains the WPF-based Windows installer scaffold for MoreVibe.

## Stack

- C#
- .NET 8
- WPF
- existing `installer/windows/install-morevibe.ps1` as the install engine

## Current scope

The UI currently includes:

- welcome screen
- target selection screen
- project path screen
- install review screen
- progress/log screen
- result screen

## Build note

The project now builds successfully on this machine with .NET 8.

To build it manually:

1. Install the .NET 8 SDK on Windows.
2. Open `MoreVibeInstaller.csproj` in Visual Studio or run `dotnet build`.

## Publish

To create a release-ready Windows bundle:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer-ui\publish-wpf-installer.ps1
```

This will:

- publish a self-contained `MoreVibeInstaller.exe`
- assemble the runtime installer assets beside it
- create a ZIP file under `dist/`
