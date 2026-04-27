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
            Log("E-TWEAKS lancé");
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
                if (path.StartsWith("http://") || path.StartsWith("https://"))
                {
                    Log("Ouverture : " + path);
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = path,
                        UseShellExecute = true
                    });
                    return;
                }

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
                Height = 64,
                Margin = new Thickness(0, 0, 0, 10),
                Background = Brushes.Transparent,
                BorderThickness = new Thickness(0),
                Cursor = System.Windows.Input.Cursors.Hand,
                HorizontalContentAlignment = HorizontalAlignment.Stretch
            };

            Border card = new Border
            {
                Background = new SolidColorBrush(Color.FromRgb(76, 76, 76)),
                CornerRadius = new CornerRadius(10),
                BorderBrush = new SolidColorBrush(Color.FromRgb(92, 92, 92)),
                BorderThickness = new Thickness(1),
                Padding = new Thickness(14)
            };

            Grid row = new Grid();
            row.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(46) });
            row.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });

            Border iconBg = new Border
            {
                Width = 34,
                Height = 34,
                Background = new SolidColorBrush(Color.FromRgb(84, 84, 84)),
                CornerRadius = new CornerRadius(8),
                VerticalAlignment = VerticalAlignment.Center
            };

            TextBlock iconBlock = new TextBlock
            {
                Text = icon,
                FontSize = 16,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center
            };

            iconBg.Child = iconBlock;

            StackPanel texts = new StackPanel
            {
                VerticalAlignment = VerticalAlignment.Center
            };

            texts.Children.Add(new TextBlock
            {
                Text = title,
                Foreground = Brushes.White,
                FontSize = 14,
                FontWeight = FontWeights.Bold
            });

            texts.Children.Add(new TextBlock
            {
                Text = subtitle,
                Foreground = new SolidColorBrush(Color.FromRgb(190, 190, 190)),
                FontSize = 11,
                Margin = new Thickness(0, 2, 0, 0)
            });

            Grid.SetColumn(iconBg, 0);
            Grid.SetColumn(texts, 1);

            row.Children.Add(iconBg);
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
            PageTitle.Text = "Bienvenue sur ";
            AccentTitle.Text = "E-TWEAKS";
            PageSubtitle.Text = "Installateurs rapides";
            Clear();

            CardsLeft.Children.Add(Card("AnyDesk", "Installer AnyDesk", "💻", "Home/Anydesk.ps1"));
            CardsLeft.Children.Add(Card("Discord", "Installer Discord", "💬", "Home/Discord.ps1"));
            CardsLeft.Children.Add(Card("Epic Games", "Installer Epic Games", "🎮", "Home/EpicGames.ps1"));

            CardsRight.Children.Add(Card("Google Chrome", "Installer Google Chrome", "🌐", "Home/Google.ps1"));
            CardsRight.Children.Add(Card("Spotify", "Installer Spotify", "🎵", "Home/Spotify.ps1"));
            CardsRight.Children.Add(Card("UserDiag", "Installer UserDiag", "👤", "Home/Userdiag.ps1"));
        }

        public void ShowWindows(object sender, RoutedEventArgs e)
        {
            PageTitle.Text = "Menu ";
            AccentTitle.Text = "Windows";
            PageSubtitle.Text = "Scripts Windows";
            Clear();

            CardsLeft.Children.Add(Card("Devices Cleanup", "Nettoyage périphériques", "🧹", "Windows/Devices-Cleanup.ps1"));
            CardsLeft.Children.Add(Card("Disabling Devices", "Device Manager", "🖥️", "Windows/Disabling Devices (Device Manager).bat"));
            CardsLeft.Children.Add(Card("Keyboard Optimizations", "Optimisations clavier registre", "⌨️", "Windows/MainKeyboard-Optimizations-Registry (2).bat"));
            CardsLeft.Children.Add(Card("System Profile Tasks", "Post Processing Registry", "🧩", "Windows/SystemProfileTasksDisplayPostProcessing.reg"));

            CardsRight.Children.Add(Card("USB Power Saving", "Désactiver économie USB", "🔌", "Windows/USBDisablePowerSaving (1).bat"));
            CardsRight.Children.Add(Card("Uninstall", "Script désinstallation", "🗑️", "Windows/UNINSTALL.bat"));
            CardsRight.Children.Add(Card("Services", "Optimisation services Windows", "⚙️", "Windows/services.cmd"));
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
            AccentTitle.Text = "Nvidia";
            PageSubtitle.Text = "Optimisations Nvidia";
            Clear();

            CardsLeft.Children.Add(Card("Disable Telemetry", "Désactiver télémétrie Nvidia", "📡", "GPU/Nvidia/!Disable telemetry (Breaks Geforce).bat"));

            CardsRight.Children.Add(Card("NVCleanstall", "Télécharger NVCleanstall", "🧼", "https://www.techpowerup.com/download/techpowerup-nvcleanstall/"));
        }
    }
}
