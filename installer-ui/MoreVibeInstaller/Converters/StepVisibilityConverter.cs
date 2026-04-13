using System.Globalization;
using System.Windows;
using System.Windows.Data;
using MoreVibeInstaller.Models;

namespace MoreVibeInstaller.Converters;

public sealed class StepVisibilityConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value is not WizardStep current || parameter is not string expected)
        {
            return Visibility.Collapsed;
        }

        return string.Equals(current.ToString(), expected, StringComparison.OrdinalIgnoreCase)
            ? Visibility.Visible
            : Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        throw new NotSupportedException();
    }
}
