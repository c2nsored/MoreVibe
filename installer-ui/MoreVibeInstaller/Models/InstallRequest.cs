namespace MoreVibeInstaller.Models;

public sealed class InstallRequest
{
    public bool InstallCodex { get; init; }
    public bool InstallClaudeCode { get; init; }
    public bool InstallAntigravity { get; init; }
    public string? ProjectPath { get; init; }
    public string? ProjectType { get; init; }
    public bool ForceProjectTemplate { get; init; }
}
