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

This machine does not currently have a .NET SDK installed, so the project was scaffolded manually and has not been compiled locally yet.

To build it:

1. Install the .NET 8 SDK on Windows.
2. Open `MoreVibeInstaller.csproj` in Visual Studio or run `dotnet build`.
