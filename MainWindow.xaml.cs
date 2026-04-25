using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace EroxUTILITY
{
    public partial class MainWindow : Window
    {
        string baseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";

        public MainWindow()
        {
            InitializeComponent();
            Log("EroxUTILITY lancé");
        }

        void Log(string msg)
        {
            LogBox.AppendText($"[{DateTime.Now:HH:mm:ss}] {msg}\n");
            LogBox.ScrollToEnd();
        }

        async Task RunScript(string path)
        {
            try
            {
                Log("Téléchargement : " + path);

                string url = baseUrl + Uri.EscapeDataString(path);
                string temp = Path.Combine(Path.GetTempPath(), Path.GetFileName(path));

                using HttpClient client = new HttpClient();
                string content = await client.GetStringAsync(url);
                await File.WriteAllTextAsync(temp, content);

                Log("Lancement : " + path);

                Process.Start(new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = $"-ExecutionPolicy Bypass -File \"{temp}\"",
                    Verb = "runas",
                    UseShellExecute = true
                });
            }
            catch (Exception ex)
            {
                Log("Erreur : " + ex.Message);
            }
        }

        Button CreateButton(string text, string path)
        {
            Button btn = new Button
            {
                Content = text,
                Margin = new Thickness(10),
                Height = 45
            };

            btn.Click += async (s, e) => await RunScript(path);

            return btn;
        }

        void ClearUI()
        {
            MainContent.Children.Clear();
        }

        public void ShowWindows(object sender, RoutedEventArgs e)
        {
            ClearUI();
            StackPanel panel = new StackPanel();

            panel.Children.Add(CreateButton("Device Cleanup", "Windows/Devices-Cleanup.ps1"));
            panel.Children.Add(CreateButton("Disable Devices", "Windows/Disabling Devices (Device Manager).bat"));

            MainContent.Children.Add(panel);
        }

        public void ShowGames(object sender, RoutedEventArgs e)
        {
            ClearUI();
            StackPanel panel = new StackPanel();

            panel.Children.Add(CreateButton("Fortnite", "Jeux/FortniteDebloat.ps1"));
            panel.Children.Add(CreateButton("Valorant", "Jeux/ValorantTool.ps1"));

            MainContent.Children.Add(panel);
        }

        public void ShowPower(object sender, RoutedEventArgs e)
        {
            ClearUI();
            StackPanel panel = new StackPanel();

            panel.Children.Add(CreateButton("PowerPlan", "PowerPlan/powerplan.ps1"));

            MainContent.Children.Add(panel);
        }

        public void ShowServices(object sender, RoutedEventArgs e)
        {
            ClearUI();
            StackPanel panel = new StackPanel();

            panel.Children.Add(CreateButton("Services", "Services/services.cmd"));
            panel.Children.Add(CreateButton("Privacy Script", "Services/privacy-script.bat"));

            MainContent.Children.Add(panel);
        }

        public void ShowGPU(object sender, RoutedEventArgs e)
        {
            ClearUI();
            StackPanel panel = new StackPanel();

            panel.Children.Add(CreateButton("Disable HDCP", "GPU/Nvidia/Disable HDCP.bat"));
            panel.Children.Add(CreateButton("Disable Telemetry", "GPU/Nvidia/Disable telemetry.bat"));

            MainContent.Children.Add(panel);
        }
    }
}
