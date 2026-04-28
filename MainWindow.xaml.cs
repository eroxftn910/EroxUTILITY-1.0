using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using Microsoft.VisualBasic;

namespace E_TWEAKS
{
    public partial class MainWindow : Window
    {
        private readonly string GitHubBaseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";

        private readonly string licensePath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            "E-TWEAKS",
            "license.txt"
        );

        private const string LicenseSecret = "CHANGE-MOI-SECRET-ER0X-2026";

        public MainWindow()
        {
            InitializeComponent();

            if (!CheckLicense())
            {
                Application.Current.Shutdown();
                return;
            }

            SetActive(BtnHome);
            LoadHome();
        }

        private string GetHWID()
        {
            string hwid = Registry.LocalMachine
                .OpenSubKey(@"SOFTWARE\Microsoft\Cryptography")
                ?.GetValue("MachineGuid")
                ?.ToString();

            return hwid ?? Environment.MachineName;
        }

        private string GenerateKey(string hwid)
        {
            using SHA256 sha = SHA256.Create();
            byte[] hash = sha.ComputeHash(Encoding.UTF8.GetBytes(hwid + LicenseSecret));

            return BitConverter.ToString(hash)
                .Replace("-", "")
                .Substring(0, 16);
        }

        private bool CheckLicense()
        {
            string hwid = GetHWID();
            string validKey = GenerateKey(hwid);

            Directory.CreateDirectory(Path.GetDirectoryName(licensePath));

            if (File.Exists(licensePath))
            {
                string savedKey = File.ReadAllText(licensePath).Trim();

                if (savedKey == validKey)
                    return true;
            }

            string inputKey = Interaction.InputBox(
                "Entre ta clé d'activation :\n\nHWID de ce PC :\n" + hwid,
                "Activation E-TWEAKS",
                ""
            ).Trim();

            if (inputKey == validKey)
            {
                File.WriteAllText(licensePath, inputKey);
                return true;
            }

            MessageBox.Show("Clé invalide pour ce PC.", "Activation refusée", MessageBoxButton.OK, MessageBoxImage.Error);
            return false;
        }

        private void SetActive(Button activeButton)
        {
            BtnHome.Style = (Style)FindResource("MenuButton");
            BtnWindows.Style = (Style)FindResource("MenuButton");
            BtnJeux.Style = (Style)FindResource("MenuButton");
            BtnPowerPlan.Style = (Style)FindResource("MenuButton");
            BtnServices.Style = (Style)FindResource("MenuButton");
            BtnNvidia.Style = (Style)FindResource("MenuButton");
            BtnSettings.Style = (Style)FindResource("MenuButton");

            activeButton.Style = (Style)FindResource("ActiveMenuButton");
        }

        private void ClearCards()
        {
            CardsGrid.Children.Clear();
        }

        private string EncodePath(string path)
        {
            return string.Join("/", path.Split('/').Select(Uri.EscapeDataString));
        }

        private void AddCard(string icon, string title, string subtitle, string path)
        {
            Button card = new Button
            {
                Style = (Style)FindResource("ActionCard"),
                Tag = path
            };

            StackPanel panel = new StackPanel();

            panel.Children.Add(new TextBlock
            {
                Text = icon,
                FontSize = 34,
                Foreground = new SolidColorBrush(Color.FromRgb(177, 92, 255)),
                Margin = new Thickness(0, 0, 0, 18)
            });

            panel.Children.Add(new TextBlock
            {
                Text = title,
                FontSize = 17,
                FontWeight = FontWeights.Bold,
                Foreground = Brushes.White
            });

            panel.Children.Add(new TextBlock
            {
                Text = subtitle,
                FontSize = 13,
                Foreground = new SolidColorBrush(Color.FromRgb(169, 164, 199)),
                Margin = new Thickness(0, 6, 0, 0)
            });

            card.Content = panel;
            card.Click += Card_Click;
            CardsGrid.Children.Add(card);
        }

        private async void Card_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button btn && btn.Tag is string path)
                await RunScript(path);
        }

        private async Task RunScript(string path)
        {
            try
            {
                if (path.StartsWith("http://") || path.StartsWith("https://"))
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = path,
                        UseShellExecute = true
                    });
                    return;
                }

                string tempFolder = Path.Combine(Path.GetTempPath(), "E-TWEAKS");
                Directory.CreateDirectory(tempFolder);

                string fileName = Path.GetFileName(path);
                string localPath = Path.Combine(tempFolder, fileName);
                string url = GitHubBaseUrl + EncodePath(path);

                using HttpClient client = new HttpClient();
                byte[] data = await client.GetByteArrayAsync(url);
                await File.WriteAllBytesAsync(localPath, data);

                string ext = Path.GetExtension(localPath).ToLower();
                ProcessStartInfo psi;

                if (ext == ".ps1")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{localPath}\"",
                        UseShellExecute = true,
                        Verb = "runas"
                    };
                }
                else if (ext == ".bat" || ext == ".cmd")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = $"/k \"{localPath}\"",
                        UseShellExecute = true,
                        Verb = "runas"
                    };
                }
                else if (ext == ".reg")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "regedit.exe",
                        Arguments = $"/s \"{localPath}\"",
                        UseShellExecute = true,
                        Verb = "runas"
                    };
                }
                else
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = localPath,
                        UseShellExecute = true,
                        Verb = "runas"
                    };
                }

                Process.Start(psi);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Impossible de télécharger ou lancer le script.\n\n" +
                    "Chemin : " + path + "\n\n" +
                    ex.Message,
                    "Erreur",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error
                );
            }
        }

        private void LoadHome()
        {
            PageTitle.Text = "Bienvenue sur E-TWEAKS";
            PageSubtitle.Text = "Installateurs rapides";
            ClearCards();

            AddCard("◆", "AnyDesk", "Installer AnyDesk", "Home/Anydesk.ps1");
            AddCard("☯", "Discord", "Installer Discord", "Home/Discord.ps1");
            AddCard("🎮", "Epic Games", "Installer Epic Games", "Home/EpicGames.ps1");
            AddCard("◉", "Google Chrome", "Installer Google Chrome", "Home/Google.ps1");
            AddCard("♫", "Spotify", "Installer Spotify", "Home/Spotify.ps1");
            AddCard("●", "UserDiag", "Installer UserDiag", "Home/Userdiag.ps1");
        }

        private void LoadWindows()
        {
            PageTitle.Text = "Menu Windows";
            PageSubtitle.Text = "Scripts Windows";
            ClearCards();

            AddCard("🧹", "Devices Cleanup", "Nettoyage périphériques", "Windows/Devices-Cleanup.ps1");
            AddCard("🖥", "Disabling Devices", "Device Manager", "Windows/Disabling Devices (Device Manager).bat");
            AddCard("⌨", "Keyboard Optimizations", "Optimisations clavier registre", "Windows/MainKeyboard-Optimizations-Registry (2).bat");
            AddCard("🧩", "System Profile Tasks", "Post Processing Registry", "Windows/SystemProfileTasksDisplayPostProcessing.reg");
            AddCard("🔌", "USB Power Saving", "Désactiver économie USB", "Windows/USBDisablePowerSaving (1).bat");
            AddCard("🗑", "Uninstall", "Script désinstallation", "Windows/UNINSTALL.bat");
            AddCard("⚙", "Services", "Optimisation services Windows", "Windows/services.cmd");
        }

        private void LoadJeux()
        {
            PageTitle.Text = "Menu Jeux";
            PageSubtitle.Text = "Optimisations gaming";
            ClearCards();

            AddCard("🎮", "Fortnite", "Optimisation Fortnite", "Jeux/Fortnite.ps1");
            AddCard("🚗", "FiveM", "Optimisation FiveM", "Jeux/FiveMTool-Windows-Optimization.ps1");
            AddCard("🧹", "Fortnite Debloat", "Installation debloat", "Jeux/FortniteDebloatInstallation.ps1");
            AddCard("🎯", "Valorant", "Optimisation Valorant", "Jeux/ValorantTool-Windows-Optimization.ps1");
        }

        private void LoadPowerPlan()
        {
            PageTitle.Text = "Menu PowerPlan";
            PageSubtitle.Text = "Plans d’alimentation";
            ClearCards();

            AddCard("⚡", "PowerPlan", "Appliquer le plan performance", "PowerPlan/Power.ps1");
        }

        private void LoadServices()
        {
            PageTitle.Text = "Menu Services";
            PageSubtitle.Text = "Optimisation services Windows";
            ClearCards();

            AddCard("⚙", "Services Optimizer", "Désactiver services inutiles", "Services/services.cmd");
        }

        private void LoadNvidia()
        {
            PageTitle.Text = "Menu Nvidia";
            PageSubtitle.Text = "Optimisations Nvidia";
            ClearCards();

            AddCard("🖥", "Disable HDCP", "Désactiver HDCP", "GPU/Nvidia/!Disable HDCP.bat");
            AddCard("◉", "Disable Telemetry", "Désactiver télémétrie Nvidia", "GPU/Nvidia/!Disable telemetry (Breaks Geforce).bat");
            AddCard("🧽", "NVCleanstall", "Télécharger NVCleanstall", "https://www.techpowerup.com/download/techpowerup-nvcleanstall/");
        }

        private void LoadSettings()
        {
            PageTitle.Text = "Paramètres";
            PageSubtitle.Text = "Configuration de l’application";
            ClearCards();
        }

        private void BtnHome_Click(object sender, RoutedEventArgs e) { SetActive(BtnHome); LoadHome(); }
        private void BtnWindows_Click(object sender, RoutedEventArgs e) { SetActive(BtnWindows); LoadWindows(); }
        private void BtnJeux_Click(object sender, RoutedEventArgs e) { SetActive(BtnJeux); LoadJeux(); }
        private void BtnPowerPlan_Click(object sender, RoutedEventArgs e) { SetActive(BtnPowerPlan); LoadPowerPlan(); }
        private void BtnServices_Click(object sender, RoutedEventArgs e) { SetActive(BtnServices); LoadServices(); }
        private void BtnNvidia_Click(object sender, RoutedEventArgs e) { SetActive(BtnNvidia); LoadNvidia(); }
        private void BtnSettings_Click(object sender, RoutedEventArgs e) { SetActive(BtnSettings); LoadSettings(); }
    }
}
