using System.Diagnostics;
using System.Windows;

namespace EroxUTILITY
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Optimize_Click(object sender, RoutedEventArgs e)
        {
            RunPowerShell("E-TWEAKS.ps1");
            RunPowerShell("Devices-Cleanup.ps1");
        }

        private void RunPowerShell(string script)
        {
            Process.Start(new ProcessStartInfo
            {
                FileName = "powershell.exe",
                Arguments = $"-ExecutionPolicy Bypass -File \"{script}\"",
                Verb = "runas",
                UseShellExecute = true
            });
        }
    }
}
