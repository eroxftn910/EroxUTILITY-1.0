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
        private void BtnJeux_Click(object sender, RoutedEventArgs e) => ShowJeux();
        private void BtnPowerPlan_Click(object sender, RoutedEventArgs e) => ShowPowerPlan();
        private void BtnServices_Click(object sender, RoutedEventArgs e) => ShowServices();
        private void BtnNvidia_Click(object sender, RoutedEventArgs e) => ShowNvidia();
        private void BtnSettings_Click(object sender, RoutedEventArgs e) => ShowSettings();

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

        private void ShowHome()
        {
            ClearCards("Bienvenue sur E-TWEAKS", "Installateurs rapides", BtnHome);

            Button windows = CreateCard("💿", "Installer Windows", "Télécharge et lance Rufus.");
            windows.Click += InstallerWindows_Click;
            CardsGrid.Children.Add(windows);

            Button bios = CreateCard("🖥️", "Redémarrer BIOS", "Redémarre directement dans le BIOS/UEFI.");
            bios.Click += RedemarrerBios_Click;
            CardsGrid.Children.Add(bios);

            Button services = CreateCard("⚙️", "Services Optimizer", "Optimise les services Windows.");
            services.Click += async (_, _) => await RunGithubScript("services.cmd");
            CardsGrid.Children.Add(services);
        }

        private void ShowWindows()
        {
            ClearCards("Menu Windows", "Installation Windows et optimisations", BtnWindows);

            Button installWindows = CreateCard("💿", "Installer Windows", "Télécharge et lance Rufus depuis GitHub.");
            installWindows.Click += InstallerWindows_Click;
            CardsGrid.Children.Add(installWindows);

            Button bios = CreateCard("🖥️", "Redémarrer BIOS", "Redémarre dans le BIOS/UEFI.");
            bios.Click += RedemarrerBios_Click;
            CardsGrid.Children.Add(bios);

            Button devicesCleanup = CreateCard("🧹", "Devices Cleanup", "Nettoie les anciens périphériques Windows.");
            devicesCleanup.Click += async (_, _) => await RunGithubScript("Devices-Cleanup.ps1");
            CardsGrid.Children.Add(devicesCleanup);
        }

        private void ShowJeux()
        {
            ClearCards("Menu Jeux", "Optimisations jeux", BtnJeux);

            Button fortnite = CreateCard("🎮", "Fortnite Optimizer", "Optimisation Fortnite.");
            fortnite.Click += async (_, _) => await RunGithubScript("FortniteDebloatInstallation (1).ps1");
            CardsGrid.Children.Add(fortnite);
        }

        private void ShowPowerPlan()
        {
            ClearCards("Menu PowerPlan", "Plans d’alimentation", BtnPowerPlan);

            Button power = CreateCard("⚡", "PowerPlan Optimizer", "Applique le plan d’alimentation optimisé.");
            power.Click += async (_, _) => await RunGithubScript("E-TWEAKS.ps1");
            CardsGrid.Children.Add(power);
        }

        private void ShowServices()
        {
            ClearCards("Menu Services", "Optimisation services Windows", BtnServices);

            Button services = CreateCard("⚙️", "Services Optimizer", "Optimise les services Windows.");
            services.Click += async (_, _) => await RunGithubScript("services.cmd");
            CardsGrid.Children.Add(services);
        }

        private void ShowNvidia()
        {
            ClearCards("Menu NVIDIA", "Optimisations GPU", BtnNvidia);

            Button nvidia = CreateCard("◉", "NVIDIA Clean Install", "Lance NVCleanstall.");
            nvidia.Click += async (_, _) => await DownloadAndRunExe(GithubBaseUrl + "NVCleanstall_1.18.0.exe", "NVCleanstall.exe");
            CardsGrid.Children.Add(nvidia);
        }

        private void ShowSettings()
        {
            ClearCards("Paramètres", "Options de l’application", BtnSettings);

            Button info = CreateCard("ℹ️", "EroxUTILITY", "Version 2.0.0");
            CardsGrid.Children.Add(info);
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
                string url = GithubBaseUrl + githubPath;
                string fileName = Path.GetFileName(githubPath);
                string tempPath = Path.Combine(Path.GetTempPath(), fileName);

                using HttpClient client = new HttpClient();
                string script = await client.GetStringAsync(url);

                await File.WriteAllTextAsync(tempPath, script);

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
