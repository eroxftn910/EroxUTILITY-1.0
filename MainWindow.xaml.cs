using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace E_TWEAKS
{
    public partial class MainWindow : Window
    {
        private readonly string ScriptFolder = "Scripts";

        public MainWindow()
        {
            InitializeComponent();
            LoadHome();
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

        private void AddCard(string icon, string title, string subtitle, string scriptName)
        {
            Button card = new Button
            {
                Style = (Style)FindResource("ActionCard"),
                Tag = scriptName
            };

            StackPanel panel = new StackPanel();

            TextBlock iconText = new TextBlock
            {
                Text = icon,
                FontSize = 34,
                Foreground = new SolidColorBrush(Color.FromRgb(177, 92, 255)),
                Margin = new Thickness(0, 0, 0, 18)
            };

            TextBlock titleText = new TextBlock
            {
                Text = title,
                FontSize = 17,
                FontWeight = FontWeights.Bold,
                Foreground = Brushes.White
            };

            TextBlock subtitleText = new TextBlock
            {
                Text = subtitle,
                FontSize = 13,
                Foreground = new SolidColorBrush(Color.FromRgb(169, 164, 199)),
                Margin = new Thickness(0, 6, 0, 0)
            };

            panel.Children.Add(iconText);
            panel.Children.Add(titleText);
            panel.Children.Add(subtitleText);

            card.Content = panel;
            card.Click += Card_Click;

            CardsGrid.Children.Add(card);
        }

        private void Card_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button btn && btn.Tag is string scriptName)
            {
                RunScript(scriptName);
            }
        }

        private void RunScript(string scriptName)
        {
            try
            {
                string scriptPath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ScriptFolder, scriptName);

                if (!System.IO.File.Exists(scriptPath))
                {
                    MessageBox.Show($"Script introuvable :\n{scriptPath}", "Erreur", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = $"-ExecutionPolicy Bypass -File \"{scriptPath}\"",
                    UseShellExecute = true,
                    Verb = "runas"
                };

                Process.Start(psi);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Erreur lancement script", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void LoadHome()
        {
            PageTitle.Text = "Bienvenue sur E-TWEAKS";
            PageSubtitle.Text = "Installateurs rapides";
            ClearCards();

            AddCard("◆", "AnyDesk", "Installer AnyDesk", "Install-AnyDesk.ps1");
            AddCard("◉", "Google Chrome", "Installer Google Chrome", "Install-Chrome.ps1");
            AddCard("☯", "Discord", "Installer Discord", "Install-Discord.ps1");
            AddCard("♫", "Spotify", "Installer Spotify", "Install-Spotify.ps1");
            AddCard("🎮", "Epic Games", "Installer Epic Games", "Install-EpicGames.ps1");
            AddCard("●", "UserDiag", "Installer UserDiag", "Install-UserDiag.ps1");
        }

        private void LoadWindows()
        {
            PageTitle.Text = "Menu Windows";
            PageSubtitle.Text = "Scripts Windows";
            ClearCards();

            AddCard("🧹", "Devices Cleanup", "Nettoyage périphériques", "Devices-Cleanup.ps1");
            AddCard("🔌", "USB Power Saving", "Désactiver économie USB", "USBDisablePowerSaving.ps1");
            AddCard("🖥", "Disabling Devices", "Device Manager", "Disabling-Devices.ps1");
            AddCard("🗑", "Uninstall", "Script désinstallation", "Uninstall.ps1");
            AddCard("⌨", "Keyboard Optimizations", "Optimisations clavier registre", "Keyboard-Optimizations.ps1");
            AddCard("⚙", "Services", "Optimisation services Windows", "Services.ps1");
            AddCard("🧩", "System Profile Tasks", "Post Processing Registry", "System-Profile-Tasks.ps1");
        }

        private void LoadJeux()
        {
            PageTitle.Text = "Menu Jeux";
            PageSubtitle.Text = "Optimisations gaming";
            ClearCards();

            AddCard("🎮", "Fortnite", "Optimisation Fortnite", "Fortnite.ps1");
            AddCard("🚗", "FiveM", "Optimisation FiveM", "FiveM.ps1");
            AddCard("🧹", "Fortnite Debloat", "Installation debloat", "Fortnite-Debloat.ps1");
            AddCard("🎯", "Valorant", "Optimisation Valorant", "Valorant.ps1");
        }

        private void LoadPowerPlan()
        {
            PageTitle.Text = "Menu PowerPlan";
            PageSubtitle.Text = "Plans d’alimentation";
            ClearCards();

            AddCard("⚡", "PowerPlan", "Appliquer le plan performance", "PowerPlan.ps1");
        }

        private void LoadServices()
        {
            PageTitle.Text = "Menu Services";
            PageSubtitle.Text = "Optimisation services Windows";
            ClearCards();

            AddCard("⚙", "Services Optimizer", "Désactiver services inutiles", "Services.ps1");
        }

        private void LoadNvidia()
        {
            PageTitle.Text = "Menu Nvidia";
            PageSubtitle.Text = "Optimisations Nvidia";
            ClearCards();

            AddCard("◉", "Disable Telemetry", "Désactiver télémétrie Nvidia", "Disable-Telemetry.ps1");
            AddCard("🧽", "NVCleanstall", "Télécharger NVCleanstall", "NVCleanstall.ps1");
        }

        private void LoadSettings()
        {
            PageTitle.Text = "Paramètres";
            PageSubtitle.Text = "Configuration de l’application";
            ClearCards();

            AddCard("📁", "Ouvrir dossier scripts", "Accéder aux fichiers", "Open-Scripts-Folder.ps1");
        }

        private void BtnHome_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnHome);
            LoadHome();
        }

        private void BtnWindows_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnWindows);
            LoadWindows();
        }

        private void BtnJeux_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnJeux);
            LoadJeux();
        }

        private void BtnPowerPlan_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnPowerPlan);
            LoadPowerPlan();
        }

        private void BtnServices_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnServices);
            LoadServices();
        }

        private void BtnNvidia_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnNvidia);
            LoadNvidia();
        }

        private void BtnSettings_Click(object sender, RoutedEventArgs e)
        {
            SetActive(BtnSettings);
            LoadSettings();
        }
    }
}
