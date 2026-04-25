using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

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
                        Arguments = $"-ExecutionPolicy Bypass -File \"{tempPath}\"",
                        Verb = "runas",
                        UseShellExecute = true
                    };
                }
                else if (ext == ".bat" || ext == ".cmd")
                {
                    psi = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = $"/c \"{tempPath}\"",
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
                Background = System.Windows.Media.Brushes.Transparent,
                BorderThickness = new Thickness(0),
                Cursor = System.Windows.Input.Cursors.Hand
            };

            btn.Content = new Border
            {
                Background = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(67, 67, 67)),
                CornerRadius = new CornerRadius(12),
                BorderBrush = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(82, 82, 82)),
                BorderThickness = new Thickness(1),
                Padding = new Thickness(18),
                Child = new StackPanel
                {
                    Orientation = Orientation.Horizontal,
                    Children =
                    {
                        new TextBlock { Text = icon, FontSize = 24, Width = 52, VerticalAlignment = VerticalAlignment.Center },
                        new StackPanel
                        {
                            Children =
                            {
                                new TextBlock { Text = title, Foreground = System.Windows.Media.Brushes.White, FontSize = 15, FontWeight = FontWeights.Bold },
                                new TextBlock { Text = subtitle, Foreground = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(190,190,190)), FontSize = 12 }
                            }
                        }
                    }
                }
            };

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
            AccentTitle.Text = "Erox Utility";
            PageSubtitle.Text = "Accès rapide à vos outils système";
            Clear();

            CardsLeft.Children.Add(Card("Réparation système", "SFC / DISM / DNS", "🛡️", "PowerPlan/Power.ps1"));
            CardsLeft.Children.Add(Card("Fortnite", "Optimisation Fortnite", "🎮", "Jeux/Fortnite.ps1"));
            CardsLeft.Children.Add(Card("FiveM", "Optimisation FiveM", "🚗", "Jeux/FiveMTool-Windows-Optimization.ps1"));

            CardsRight.Children.Add(Card("Valorant", "Optimisation Valorant", "🎯", "Jeux/ValorantTool-Windows-Optimization.ps1"));
            CardsRight.Children.Add(Card("Fortnite Debloat", "Nettoyage Fortnite", "🧹", "Jeux/FortniteDebloatInstallation.ps1"));
            CardsRight.Children.Add(Card("PowerPlan", "Plan alimentation", "⚡", "PowerPlan/Power.ps1"));
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
    }
}
