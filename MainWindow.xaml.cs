using System.Diagnostics;
using System.IO;
using System.Windows;

namespace EroxUTILITY
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Log("EroxUTILITY lancé");
        }

        void Log(string msg)
        {
            LogsBox.Text += msg + "\n";
        }

        void RunScript(string path)
        {
            if (!File.Exists(path))
            {
                Log("Fichier introuvable: " + path);
                return;
            }

            Process.Start(new ProcessStartInfo()
            {
                FileName = "powershell.exe",
                Arguments = "-ExecutionPolicy Bypass -File \"" + path + "\"",
                Verb = "runas"
            });

            Log("Lancé: " + path);
        }

        // MENUS
        private void MenuHome(object sender, RoutedEventArgs e)
        {
            Log("Menu Home");
        }

        private void MenuWindows(object sender, RoutedEventArgs e)
        {
            RunScript("scripts/windows/Devices-Cleanup.ps1");
        }

        private void MenuGames(object sender, RoutedEventArgs e)
        {
            RunScript("scripts/games/Fortnite.ps1");
        }

        private void MenuPower(object sender, RoutedEventArgs e)
        {
            RunScript("scripts/powerplan/Power.ps1");
        }

        private void MenuServices(object sender, RoutedEventArgs e)
        {
            RunScript("scripts/services/services.cmd");
        }

        private void MenuGPU(object sender, RoutedEventArgs e)
        {
            RunScript("scripts/gpu/nvidia/Disable-HDCP.bat");
        }
    }
}
