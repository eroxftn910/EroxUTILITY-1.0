using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace EroxUTILITY
{
    public partial class MainWindow : Window
    {
        private const string BaseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";

        public MainWindow()
        {
            InitializeComponent();
            ShowHome(null, null);
            Log("EroxUTILITY lancé");
        }

        private string EncodePath(string path)
        {
            return string.Join("/", path.Split('/').Select(Uri.EscapeDataString));
        }

        private void Log(string message)
        {
            LogsBox.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}\n");
            LogsBox.ScrollToEnd();
        }

        private async Task RunFromGitHub(string path)
        {
            try
            {
                string url = BaseUrl + EncodePath(path);
                string tempPath = Path.Combine(Path.GetTempPath(), Path.GetFileName(path));

                Log("Téléchargement : " + path);

                using HttpClient client = new HttpClient();
                byte[] data = await client.GetByteArrayAsync(url);
                await File.WriteAllBytesAsync(tempPath, data);

                Log("Lancement admin : " + path);

                string ext = Path.GetExtension(path).ToLower();

                ProcessStartInfo psi;

                if (ext == ".ps1")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-NoExit -ExecutionPolicy Bypass -File \"{tempPath}\"",
                        Verb = "runas",
                        UseShellExecute = true
                    };
                }
                else if (ext == ".bat" || ext == ".cmd")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = $"/k \"{tempPath}\"",
                        Verb = "runas",
                        UseShellExecute = true
                    };
                }
                else if (ext == ".reg")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "regedit.exe",
                        Arguments = $"/s \"{tempPath}\"",
                        Verb = "runas",
                        UseShellExecute = true
                    };
                }
                else
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = tempPath,
                        Verb = "runas",
                        UseShellExecute = true
                    };
                }

                Process.Start(psi);
            }
            catch (Exception ex)
            {
                Log("ERREUR : " + ex.Message);
            }
        }

        private Button Card(string title, string subtitle, string icon, string path)
        {
            Button btn = new Button
            {
                Height = 78,
                Margin = new Thickness(0, 0, 14, 14),
                Background = Brushes.Transparent,
                BorderThickness = new Thickness(0),
                Cursor = System.Windows.Input.Cursors.Hand
            };

            Border card = new Border
            {
                Background = new SolidColorBrush(Color.FromRgb(67, 67, 67)),
                CornerRadius = new CornerRadius(12),
                BorderBrush = new SolidColorBrush(Color.FromRgb(82, 82, 82)),
                BorderThickness = new Thickness(1),
                Padding = new Thickness(18)
            };

            StackPanel row = new StackPanel
            {
                Orientation = Orientation.Horizontal
            };

            TextBlock iconBlock = new TextBlock
            {
                Text = icon,
                FontSize = 24,
                Width = 52,
                VerticalAlignment = VerticalAlignment.Center
            };

            StackPanel texts = new StackPanel();

            texts.Children.Add(new TextBlock
            {
                Text = title,
                Foreground = Brushes.White,
                FontSize = 15,
                FontWeight = FontWeights.Bold
            });

            texts.Children.Add(new TextBlock
            {
                Text = subtitle,
                Foreground = new SolidColorBrush(Color.FromRgb(190, 190, 190)),
                FontSize = 12
            });

            row.Children.Add(iconBlock);
            row.Children.Add(texts);
            card.Child = row;
            btn.Content = card;

            btn.Click += async (s, e) => await RunFromGitHub(path);

            return btn;
        }

        private void Clear()
        {
            CardsLeft.Children.Clear();
            CardsRight.Children.Clear();
        }

        public void ShowHome(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "Windows";
            PageSubtitle.Text = "Tweaks système Windows";
            Clear();

            CardsLeft.Children.Add(Card("Device Cleanup", "Nettoyage périphériques", "🧹", "TWEAKS/Devices-Cleanup.ps1"));
            CardsLeft.Children.Add(Card("Disabling Devices", "Device Manager", "🖥️", "TWEAKS/Disabling Devices (Device Manager).bat"));

            CardsRight.Children.Add(Card("Keyboard Optimizations", "Optimisations clavier registre", "⌨️", "TWEAKS/MainKeyboard-Optimizations-Registry (2).bat"));
            CardsRight.Children.Add(Card("USB Power Saving", "Désactiver économie USB", "🔌", "TWEAKS/USBDisablePowerSaving (1).bat"));
        }

        public void ShowGames(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "Jeux";
            PageSubtitle.Text = "Optimisations gaming";
            Clear();

            CardsLeft.Children.Add(Card("Fortnite", "Optimisation Fortnite", "🎮", "Jeux/Fortnite.ps1"));
            CardsLeft.Children.Add(Card("Fortnite Debloat", "Installation debloat", "🧹", "Jeux/FortniteDebloatInstallation.ps1"));

            CardsRight.Children.Add(Card("FiveM", "Optimisation FiveM", "🚗", "Jeux/FiveMTool-Windows-Optimization.ps1"));
            CardsRight.Children.Add(Card("Valorant", "Optimisation Valorant", "🎯", "Jeux/ValorantTool-Windows-Optimization.ps1"));
        }

        public void ShowPower(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "PowerPlan";
            PageSubtitle.Text = "Plans d’alimentation";
            Clear();

            CardsLeft.Children.Add(Card("PowerPlan", "Appliquer le plan performance", "⚡", "PowerPlan/Power.ps1"));
        }

        public void ShowServices(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "Services";
            PageSubtitle.Text = "Gestion et confidentialité";
            Clear();

            CardsLeft.Children.Add(Card("Privacy Script", "Confidentialité Windows", "🔒", "Services/privacy-script.bat"));
            CardsRight.Children.Add(Card("Services", "Optimisation services", "⚙️", "Services/services.cmd"));
        }

        public void ShowGPU(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "GPU";
            PageSubtitle.Text = "Optimisations Nvidia";
            Clear();

            CardsLeft.Children.Add(Card("Disable HDCP", "Désactiver HDCP", "🖥️", "GPU/Nvidia/!Disable HDCP.bat"));
            CardsLeft.Children.Add(Card("Disable Telemetry", "Désactiver télémétrie Nvidia", "📡", "GPU/Nvidia/!Disable telemetry (Breaks Geforce).bat"));
            CardsLeft.Children.Add(Card("No ECC", "Désactiver ECC", "🧩", "GPU/Nvidia/!No ECC.bat"));

            CardsRight.Children.Add(Card("P-State 0", "Forcer performance GPU", "⚡", "GPU/Nvidia/!P-State 0.bat"));
            CardsRight.Children.Add(Card("MPO Disable", "Désactiver MPO", "🛠️", "GPU/Nvidia/mpo disable.bat"));
            CardsRight.Children.Add(Card("NVCleanstall", "Installer Nvidia propre", "🧼", "GPU/Nvidia/NVCleanstall_1.18.0.exe"));
        }
    }
}
