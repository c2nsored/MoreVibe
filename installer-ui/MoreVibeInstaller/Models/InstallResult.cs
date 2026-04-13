namespace MoreVibeInstaller.Models;

public sealed class InstallResult
{
    public bool Success { get; init; }
    public int ExitCode { get; init; }
    public string Summary { get; init; } = string.Empty;
}
