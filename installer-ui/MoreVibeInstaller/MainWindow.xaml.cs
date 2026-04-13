using System.Windows;
using MoreVibeInstaller.ViewModels;

namespace MoreVibeInstaller;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        var viewModel = new MainViewModel();
        viewModel.CloseRequested += (_, _) => Close();
        DataContext = viewModel;
    }
}
