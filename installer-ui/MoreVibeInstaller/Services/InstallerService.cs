using System.Diagnostics;
using System.IO;
using System.Text;
using MoreVibeInstaller.Models;

namespace MoreVibeInstaller.Services;

public sealed class InstallerService
{
    public async Task<InstallResult> RunAsync(InstallRequest request, Action<string> onLog, CancellationToken cancellationToken)
    {
        var scriptPath = FindInstallerScript();
        if (scriptPath is null)
        {
            return new InstallResult
            {
                Success = false,
                ExitCode = -1,
                Summary = "install-morevibe.ps1 파일을 찾지 못했습니다."
            };
        }

        var startInfo = new ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = BuildArguments(scriptPath, request),
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true,
            StandardOutputEncoding = Encoding.UTF8,
            StandardErrorEncoding = Encoding.UTF8
        };

        using var process = new Process { StartInfo = startInfo };
        process.OutputDataReceived += (_, args) =>
        {
            if (args.Data is not null)
            {
                onLog(args.Data);
            }
        };
        process.ErrorDataReceived += (_, args) =>
        {
            if (args.Data is not null)
            {
                onLog("[ERROR] " + args.Data);
            }
        };

        process.Start();
        process.BeginOutputReadLine();
        process.BeginErrorReadLine();
        await process.WaitForExitAsync(cancellationToken);

        return new InstallResult
        {
            Success = process.ExitCode == 0,
            ExitCode = process.ExitCode,
            Summary = process.ExitCode == 0
                ? "설치가 완료되었습니다. 이제 선택한 AI 환경에서 새 세션을 시작할 수 있습니다."
                : $"설치가 실패했습니다. 종료 코드: {process.ExitCode}"
        };
    }

    private static string BuildArguments(string scriptPath, InstallRequest request)
    {
        var parts = new List<string>
        {
            "-ExecutionPolicy Bypass",
            $"-File \"{scriptPath}\""
        };

        if (request.InstallCodex) parts.Add("-InstallCodex");
        if (request.InstallClaudeCode) parts.Add("-InstallClaudeCode");
        if (request.InstallAntigravity) parts.Add("-InstallAntigravity");
        if (!string.IsNullOrWhiteSpace(request.ProjectPath)) parts.Add($"-ProjectPath \"{request.ProjectPath}\"");
        if (request.ForceProjectTemplate) parts.Add("-ForceProjectTemplate");

        return string.Join(" ", parts);
    }

    private static string? FindInstallerScript()
    {
        var current = AppContext.BaseDirectory;
        for (var i = 0; i < 6; i++)
        {
            var candidate = Path.Combine(current, "installer", "windows", "install-morevibe.ps1");
            if (File.Exists(candidate))
            {
                return candidate;
            }

            current = Path.GetFullPath(Path.Combine(current, ".."));
        }

        return null;
    }
}
