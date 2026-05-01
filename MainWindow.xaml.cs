using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace E_TWEAKS
{
    public partial class MainWindow : Window
    {
        private const string GithubBaseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";

        public MainWindow()
        {
            InitializeComponent();
            ShowHome();
        }

        private void BtnHome_Click(object sender, RoutedEventArgs e) => ShowHome();
        private void BtnWindows_Click(object sender, RoutedEventArgs e) => ShowWindows();
        private void BtnInstallWindows_Click(object sender, RoutedEventArgs e) => ShowInstallWindows();
        private void BtnJeux_Click(object sender, RoutedEventArgs e) => ShowJeux();
        private void BtnPowerPlan_Click(object sender, RoutedEventArgs e) => ShowPowerPlan();
        private void BtnServices_Click(object sender, RoutedEventArgs e) => ShowServices();
        private void BtnNvidia_Click(object sender, RoutedEventArgs e) => ShowNvidia();
        private void BtnSettings_Click(object sender, RoutedEventArgs e) => ShowSettings();

        private void SetActive(Button activeButton)
        {
            BtnHome.Style = (Style)FindResource("MenuButton");
            BtnWindows.Style = (Style)FindResource("MenuButton");
            BtnInstallWindows.Style = (Style)FindResource("MenuButton");
            BtnJeux.Style = (Style)FindResource("MenuButton");
            BtnPowerPlan.Style = (Style)FindResource("MenuButton");
            BtnServices.Style = (Style)FindResource("MenuButton");
            BtnNvidia.Style = (Style)FindResource("MenuButton");
            BtnSettings.Style = (Style)FindResource("MenuButton");

            activeButton.Style = (Style)FindResource("ActiveMenuButton");
        }

        private void ClearCards(string title, string subtitle, Button activeButton)
        {
            SetActive(activeButton);
            PageTitle.Text = title;
            PageSubtitle.Text = subtitle;
            CardsGrid.Children.Clear();
        }

        private Button CreateCard(string icon, string title, string subtitle)
        {
            StackPanel stack = new StackPanel();

            stack.Children.Add(new TextBlock
            {
                Text = icon,
                FontSize = 34,
                Foreground = Brushes.White,
                Margin = new Thickness(0, 0, 0, 12)
            });

            stack.Children.Add(new TextBlock
            {
                Text = title,
                Foreground = Brushes.White,
                FontSize = 18,
                FontWeight = FontWeights.Bold
            });

            stack.Children.Add(new TextBlock
            {
                Text = subtitle,
                Foreground = new SolidColorBrush(Color.FromRgb(169, 164, 199)),
                FontSize = 13,
                Margin = new Thickness(0, 8, 0, 0),
                TextWrapping = TextWrapping.Wrap
            });

            return new Button
            {
                Style = (Style)FindResource("ActionCard"),
                Content = stack
            };
        }

        private void AddGithubCard(string icon, string title, string subtitle, string githubPath)
        {
            Button card = CreateCard(icon, title, subtitle);
            card.Click += async (_, _) => await RunGithubScript(githubPath);
            CardsGrid.Children.Add(card);
        }

        private void AddActionCard(string icon, string title, string subtitle, RoutedEventHandler click)
        {
            Button card = CreateCard(icon, title, subtitle);
            card.Click += click;
            CardsGrid.Children.Add(card);
        }

        private void ShowHome()
        {
            ClearCards("Bienvenue sur E-TWEAKS", "Installateurs rapides", BtnHome);

            AddGithubCard("🧹", "Devices Cleanup", "Nettoyage périphériques Windows.", "Devices-Cleanup.ps1");
            AddGithubCard("🎮", "Fortnite", "Optimisation Fortnite.", "FortniteDebloatInstallation (1).ps1");
            AddGithubCard("⚡", "PowerPlan", "Plan d’alimentation optimisé.", "E-TWEAKS.ps1");
            AddGithubCard("⚙️", "Services Optimizer", "Optimise les services Windows.", "services.cmd");
        }

        private void ShowInstallWindows()
        {
            ClearCards("Installer Windows", "Création clé USB Windows avec Rufus", BtnInstallWindows);

            AddActionCard("💿", "Installer Windows", "Télécharge et lance Rufus.", InstallerWindows_Click);
            AddActionCard("🖥️", "Redémarrer BIOS", "Redémarre directement dans le BIOS/UEFI.", RedemarrerBios_Click);
        }

        private void ShowWindows()
        {
            ClearCards("Menu Windows", "Scripts Windows", BtnWindows);

            AddGithubCard("🧹", "Devices Cleanup", "Nettoie les anciens périphériques Windows.", "Devices-Cleanup.ps1");
            AddGithubCard("🖥️", "Disabling Devices", "Optimisation Device Manager.", "Disabling Devices (Device Manager).bat");
            AddGithubCard("⌨️", "Keyboard Optimizations", "Optimisations clavier registre.", "MainKeyboard-Optimizations-Registry (2).bat");
            AddGithubCard("🧩", "System Profile Tasks", "Post processing système.", "SystemProfileTasksDisplayPostProcessing.reg");
            AddGithubCard("🔌", "USB Power Saving", "Désactive économie USB.", "USBDisablePowerSaving (1).bat");
            AddGithubCard("🗑️", "Uninstall", "Nettoyage/désinstallation.", "Uninstall.bat");
        }

        private void ShowJeux()
        {
            ClearCards("Menu Jeux", "Optimisations gaming", BtnJeux);

            AddGithubCard("🎮", "Fortnite", "Optimisation Fortnite.", "FortniteDebloatInstallation (1).ps1");
            AddGithubCard("🚗", "FiveM", "Optimisation FiveM.", "FiveMTool-Windows-Optimization.ps1");
            AddGithubCard("🧹", "Fortnite Debloat", "Debloat Fortnite.", "FortniteDebloatInstallation (1).ps1");
            AddGithubCard("🎯", "Valorant", "Optimisation Valorant.", "ValorantTool-Windows-Optimization.ps1");
        }

        private void ShowPowerPlan()
        {
            ClearCards("Menu PowerPlan", "Plans d’alimentation", BtnPowerPlan);

            AddGithubCard("⚡", "PowerPlan", "Applique le PowerPlan.", "E-TWEAKS.ps1");
        }

        private void ShowServices()
        {
            ClearCards("Menu Services", "Optimisation services Windows", BtnServices);

            AddGithubCard("⚙️", "Services Optimizer", "Optimise les services Windows.", "services.cmd");
        }

        private void ShowNvidia()
        {
            ClearCards("Menu Nvidia", "Optimisations Nvidia", BtnNvidia);

            AddGithubCard("⭕", "Disable Telemetry", "Désactive télémétrie NVIDIA.", "mpo disable.bat");
        }

        private void ShowSettings()
        {
            ClearCards("Paramètres", "Options de l’application", BtnSettings);

            AddGithubCard("ℹ️", "MPO Disable REG", "Désactive MPO via registre.", "Mpo_disable.reg");
            AddGithubCard("ℹ️", "Settings NIP", "Import paramètres.", "Settings.nip");
        }

        private async void InstallerWindows_Click(object sender, RoutedEventArgs e)
        {
            await DownloadAndRunExe(
                "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/rufus.exe",
                "rufus.exe"
            );
        }

        private void RedemarrerBios_Click(object sender, RoutedEventArgs e)
        {
            MessageBoxResult result = MessageBox.Show(
                "Le PC va redémarrer dans le BIOS/UEFI.\nContinuer ?",
                "Redémarrage BIOS",
                MessageBoxButton.YesNo,
                MessageBoxImage.Warning
            );

            if (result != MessageBoxResult.Yes)
                return;

            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = "shutdown",
                    Arguments = "/r /fw /t 0",
                    UseShellExecute = true,
                    Verb = "runas"
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erreur BIOS :\n\n" + ex.Message);
            }
        }

        private async Task DownloadAndRunExe(string url, string fileName)
        {
            try
            {
                string tempPath = Path.Combine(Path.GetTempPath(), fileName);

                using HttpClient client = new HttpClient();
                byte[] data = await client.GetByteArrayAsync(url);

                await File.WriteAllBytesAsync(tempPath, data);

                Process.Start(new ProcessStartInfo
                {
                    FileName = tempPath,
                    UseShellExecute = true,
                    Verb = "runas"
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Impossible de télécharger ou lancer le fichier.\n\n" + ex.Message,
                    "Erreur",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error
                );
            }
        }

        private async Task RunGithubScript(string githubPath)
        {
            try
            {
                string url = GithubBaseUrl + Uri.EscapeUriString(githubPath);
                string fileName = Path.GetFileName(githubPath);
                string tempPath = Path.Combine(Path.GetTempPath(), fileName);

                using HttpClient client = new HttpClient();
                byte[] data = await client.GetByteArrayAsync(url);

                await File.WriteAllBytesAsync(tempPath, data);

                if (githubPath.EndsWith(".ps1", StringComparison.OrdinalIgnoreCase))
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-ExecutionPolicy Bypass -File \"{tempPath}\"",
                        UseShellExecute = true,
                        Verb = "runas"
                    });
                }
                else if (githubPath.EndsWith(".reg", StringComparison.OrdinalIgnoreCase))
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = "regedit.exe",
                        Arguments = $"/s \"{tempPath}\"",
                        UseShellExecute = true,
                        Verb = "runas"
                    });
                }
                else
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = tempPath,
                        UseShellExecute = true,
                        Verb = "runas"
                    });
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Impossible de télécharger ou lancer le script.\n\n" +
                    "Chemin : " + githubPath + "\n\n" +
                    ex.Message,
                    "Erreur",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error
                );
            }
        }
    }
}
