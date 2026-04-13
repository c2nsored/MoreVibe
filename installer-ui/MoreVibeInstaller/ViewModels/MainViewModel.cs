using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Windows.Forms;
using System.Windows.Input;
using MoreVibeInstaller.Models;
using MoreVibeInstaller.Services;

namespace MoreVibeInstaller.ViewModels;

public sealed class MainViewModel : ViewModelBase
{
    private readonly InstallerService _installerService = new();
    private WizardStep _currentStep = WizardStep.Welcome;
    private bool _installCodex = true;
    private bool _installClaudeCode = true;
    private bool _installAntigravity = true;
    private bool _skipProjectBootstrap;
    private bool _forceProjectTemplate;
    private bool _isInstalling;
    private bool _installSucceeded;
    private string _projectPath = string.Empty;
    private string _statusText = "설치를 시작할 준비가 되었습니다.";
    private string _resultTitle = string.Empty;
    private string _resultMessage = string.Empty;

    public MainViewModel()
    {
        Steps = new ReadOnlyCollection<string>(new[]
        {
            "환영",
            "대상 선택",
            "프로젝트 설정",
            "설치 확인",
            "설치 진행",
            "완료"
        });

        Logs = new ObservableCollection<string>();
        NextCommand = new RelayCommand(NextStep, CanMoveForward);
        BackCommand = new RelayCommand(BackStep, CanMoveBackward);
        BrowseProjectPathCommand = new RelayCommand(BrowseProjectPath, () => !SkipProjectBootstrap && !IsInstalling);
        OpenProjectFolderCommand = new RelayCommand(OpenProjectFolder, () => !string.IsNullOrWhiteSpace(ProjectPath) && Directory.Exists(ProjectPath));
        CloseCommand = new RelayCommand(() => CloseRequested?.Invoke(this, EventArgs.Empty));
    }

    public event EventHandler? CloseRequested;

    public ReadOnlyCollection<string> Steps { get; }
    public ObservableCollection<string> Logs { get; }
    public ICommand NextCommand { get; }
    public ICommand BackCommand { get; }
    public ICommand BrowseProjectPathCommand { get; }
    public ICommand OpenProjectFolderCommand { get; }
    public ICommand CloseCommand { get; }

    public WizardStep CurrentStep
    {
        get => _currentStep;
        set
        {
            if (SetProperty(ref _currentStep, value))
            {
                OnPropertyChanged(nameof(CurrentStepTitle));
                RaiseCommandStates();
            }
        }
    }

    public string CurrentStepTitle => CurrentStep switch
    {
        WizardStep.Welcome => "MoreVibe 설치 시작",
        WizardStep.Targets => "설치 대상 선택",
        WizardStep.Project => "프로젝트 경로 설정",
        WizardStep.Review => "설치 내용 확인",
        WizardStep.Progress => "설치 진행 중",
        WizardStep.Result => "설치 결과",
        _ => "MoreVibe Installer"
    };

    public bool InstallCodex
    {
        get => _installCodex;
        set
        {
            if (SetProperty(ref _installCodex, value))
            {
                RaiseCommandStates();
                OnPropertyChanged(nameof(TargetSummary));
            }
        }
    }

    public bool InstallClaudeCode
    {
        get => _installClaudeCode;
        set
        {
            if (SetProperty(ref _installClaudeCode, value))
            {
                RaiseCommandStates();
                OnPropertyChanged(nameof(TargetSummary));
            }
        }
    }

    public bool InstallAntigravity
    {
        get => _installAntigravity;
        set
        {
            if (SetProperty(ref _installAntigravity, value))
            {
                RaiseCommandStates();
                OnPropertyChanged(nameof(TargetSummary));
            }
        }
    }

    public bool SkipProjectBootstrap
    {
        get => _skipProjectBootstrap;
        set
        {
            if (SetProperty(ref _skipProjectBootstrap, value))
            {
                if (value)
                {
                    ProjectPath = string.Empty;
                }

                RaiseCommandStates();
                OnPropertyChanged(nameof(ProjectSummary));
            }
        }
    }

    public bool ForceProjectTemplate
    {
        get => _forceProjectTemplate;
        set => SetProperty(ref _forceProjectTemplate, value);
    }

    public bool IsInstalling
    {
        get => _isInstalling;
        private set
        {
            if (SetProperty(ref _isInstalling, value))
            {
                RaiseCommandStates();
            }
        }
    }

    public string ProjectPath
    {
        get => _projectPath;
        set
        {
            if (SetProperty(ref _projectPath, value))
            {
                RaiseCommandStates();
                OnPropertyChanged(nameof(ProjectSummary));
                OnPropertyChanged(nameof(LogsText));
            }
        }
    }

    public string StatusText
    {
        get => _statusText;
        private set => SetProperty(ref _statusText, value);
    }

    public string LogsText => string.Join(Environment.NewLine, Logs);

    public bool InstallSucceeded
    {
        get => _installSucceeded;
        private set => SetProperty(ref _installSucceeded, value);
    }

    public string ResultTitle
    {
        get => _resultTitle;
        private set => SetProperty(ref _resultTitle, value);
    }

    public string ResultMessage
    {
        get => _resultMessage;
        private set => SetProperty(ref _resultMessage, value);
    }

    public string TargetSummary
    {
        get
        {
            var targets = new List<string>();
            if (InstallCodex) targets.Add("Codex");
            if (InstallClaudeCode) targets.Add("Claude Code");
            if (InstallAntigravity) targets.Add("Antigravity");
            return targets.Count == 0 ? "선택된 대상 없음" : string.Join(", ", targets);
        }
    }

    public string ProjectSummary =>
        SkipProjectBootstrap || string.IsNullOrWhiteSpace(ProjectPath)
            ? "프로젝트 부트스트랩 건너뜀"
            : ProjectPath;

    private void BrowseProjectPath()
    {
        using var dialog = new FolderBrowserDialog
        {
            Description = "MoreVibe를 적용할 프로젝트 루트 폴더를 선택하세요.",
            UseDescriptionForTitle = true,
            ShowNewFolderButton = false
        };

        if (Directory.Exists(ProjectPath))
        {
            dialog.InitialDirectory = ProjectPath;
        }

        if (dialog.ShowDialog() == DialogResult.OK)
        {
            ProjectPath = dialog.SelectedPath;
        }
    }

    private bool CanMoveForward()
    {
        if (IsInstalling)
        {
            return false;
        }

        return CurrentStep switch
        {
            WizardStep.Welcome => true,
            WizardStep.Targets => InstallCodex || InstallClaudeCode || InstallAntigravity,
            WizardStep.Project => SkipProjectBootstrap || Directory.Exists(ProjectPath),
            WizardStep.Review => true,
            _ => false
        };
    }

    private bool CanMoveBackward()
    {
        return !IsInstalling && CurrentStep is WizardStep.Targets or WizardStep.Project or WizardStep.Review;
    }

    private async void NextStep()
    {
        switch (CurrentStep)
        {
            case WizardStep.Welcome:
                CurrentStep = WizardStep.Targets;
                break;
            case WizardStep.Targets:
                CurrentStep = WizardStep.Project;
                break;
            case WizardStep.Project:
                CurrentStep = WizardStep.Review;
                break;
            case WizardStep.Review:
                await StartInstallAsync();
                break;
        }
    }

    private void BackStep()
    {
        CurrentStep = CurrentStep switch
        {
            WizardStep.Targets => WizardStep.Welcome,
            WizardStep.Project => WizardStep.Targets,
            WizardStep.Review => WizardStep.Project,
            _ => CurrentStep
        };
    }

    private async Task StartInstallAsync()
    {
        Logs.Clear();
        OnPropertyChanged(nameof(LogsText));
        CurrentStep = WizardStep.Progress;
        IsInstalling = true;
        StatusText = "MoreVibe 설치를 시작합니다...";

        var result = await _installerService.RunAsync(
            new InstallRequest
            {
                InstallCodex = InstallCodex,
                InstallClaudeCode = InstallClaudeCode,
                InstallAntigravity = InstallAntigravity,
                ProjectPath = SkipProjectBootstrap ? null : ProjectPath,
                ForceProjectTemplate = ForceProjectTemplate
            },
            AddLog,
            CancellationToken.None);

        InstallSucceeded = result.Success;
        ResultTitle = result.Success ? "설치가 완료되었습니다" : "설치 중 문제가 발생했습니다";
        ResultMessage = result.Summary;
        StatusText = result.Summary;
        CurrentStep = WizardStep.Result;
        IsInstalling = false;
    }

    private void AddLog(string message)
    {
        App.Current.Dispatcher.Invoke(() =>
        {
            Logs.Add(message);
            StatusText = message;
            OnPropertyChanged(nameof(LogsText));
        });
    }

    private void OpenProjectFolder()
    {
        if (string.IsNullOrWhiteSpace(ProjectPath) || !Directory.Exists(ProjectPath))
        {
            return;
        }

        Process.Start(new ProcessStartInfo
        {
            FileName = "explorer.exe",
            Arguments = $"\"{ProjectPath}\"",
            UseShellExecute = true
        });
    }

    private void RaiseCommandStates()
    {
        (NextCommand as RelayCommand)?.RaiseCanExecuteChanged();
        (BackCommand as RelayCommand)?.RaiseCanExecuteChanged();
        (BrowseProjectPathCommand as RelayCommand)?.RaiseCanExecuteChanged();
        (OpenProjectFolderCommand as RelayCommand)?.RaiseCanExecuteChanged();
    }
}
