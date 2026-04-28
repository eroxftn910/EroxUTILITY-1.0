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

namespace E_TWEAKS
{
    public partial class MainWindow : Window
    {
        private readonly string GitHubBaseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";

        private const string LicenseSecret = "ER0X-SECRET-2026";

        private readonly string licensePath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            "E-TWEAKS",
            "license.txt"
        );

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

            return hwid?.Trim() ?? Environment.MachineName.Trim();
        }

        private string GenerateKey(string hwid)
        {
            string data = hwid.Trim() + LicenseSecret;

            using SHA256 sha = SHA256.Create();
            byte[] bytes = Encoding.UTF8.GetBytes(data);
            byte[] hash = sha.ComputeHash(bytes);

            return BitConverter.ToString(hash)
                .Replace("-", "")
                .Substring(0, 16)
                .ToUpper();
        }

        private bool CheckLicense()
        {
            string hwid = GetHWID();
            string validKey = GenerateKey(hwid);

            Directory.CreateDirectory(Path.GetDirectoryName(licensePath));

            if (File.Exists(licensePath))
            {
                string savedKey = File.ReadAllText(licensePath).Trim().ToUpper();

                if (savedKey == validKey)
                    return true;
            }

            Window activationWindow = new Window
            {
                Title = "Activation E-TWEAKS",
                Width = 460,
                Height = 360,
                WindowStartupLocation = WindowStartupLocation.CenterScreen,
                ResizeMode = ResizeMode.NoResize,
                Background = new SolidColorBrush(Color.FromRgb(18, 18, 28))
            };

            StackPanel panel = new StackPanel
            {
                Margin = new Thickness(24)
            };

            TextBlock title = new TextBlock
            {
                Text = "Activation requise",
                Foreground = Brushes.White,
                FontSize = 24,
                FontWeight = FontWeights.Bold,
                Margin = new Thickness(0, 0, 0, 18)
            };

            TextBlock hwidLabel = new TextBlock
            {
                Text = "HWID de ce PC :",
                Foreground = new SolidColorBrush(Color.FromRgb(190, 175, 255)),
                FontSize = 13
            };

            TextBox hwidBox = new TextBox
            {
                Text = hwid,
                IsReadOnly = true,
                Background = new SolidColorBrush(Color.FromRgb(35, 35, 50)),
                Foreground = Brushes.White,
                BorderBrush = new SolidColorBrush(Color.FromRgb(130, 70, 255)),
                Margin = new Thickness(0, 6, 0, 10),
                Padding = new Thickness(8)
            };

            Button copyButton = new Button
            {
                Content = "Copier HWID",
                Height = 36,
                Background = new SolidColorBrush(Color.FromRgb(130, 70, 255)),
                Foreground = Brushes.White,
                BorderThickness = new Thickness(0),
                Margin = new Thickness(0, 0, 0, 18),
                Cursor = System.Windows.Input.Cursors.Hand
            };

            TextBlock keyLabel = new TextBlock
            {
                Text = "Clé d'activation :",
                Foreground = new SolidColorBrush(Color.FromRgb(190, 175, 255)),
                FontSize = 13
            };

            TextBox keyBox = new TextBox
            {
                Background = new SolidColorBrush(Color.FromRgb(35, 35, 50)),
                Foreground = Brushes.White,
                BorderBrush = new SolidColorBrush(Color.FromRgb(130, 70, 255)),
                Margin = new Thickness(0, 6, 0, 16),
                Padding = new Thickness(8)
            };

            Button activateButton = new Button
            {
                Content = "Activer / Continuer",
                Height = 40,
                Background = new SolidColorBrush(Color.FromRgb(130, 70, 255)),
                Foreground = Brushes.White,
                BorderThickness = new Thickness(0),
                Cursor = System.Windows.Input.Cursors.Hand
            };

            bool activated = false;

            copyButton.Click += (s, e) =>
            {
                Clipboard.SetText(hwid);
                MessageBox.Show("HWID copié.", "E-TWEAKS");
            };

            activateButton.Click += (s, e) =>
            {
                string enteredKey = keyBox.Text.Trim().ToUpper();

                if (enteredKey == validKey)
                {
                    File.WriteAllText(licensePath, validKey);
                    activated = true;
                    MessageBox.Show("Activation réussie.", "E-TWEAKS");
                    activationWindow.Close();
                }
                else
                {
                    MessageBox.Show(
                        "Clé invalide pour ce PC.\n\nVérifie que tu as généré la clé avec ce HWID :\n" + hwid,
                        "Erreur",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error
                    );
                }
            };

            panel.Children.Add(title);
            panel.Children.Add(hwidLabel);
            panel.Children.Add(hwidBox);
            panel.Children.Add(copyButton);
            panel.Children.Add(keyLabel);
            panel.Children.Add(keyBox);
            panel.Children.Add(activateButton);

            activationWindow.Content = panel;
            activationWindow.ShowDialog();

            return activated;
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
