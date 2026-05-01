private async void ServicesOptimizer_Click(object sender, RoutedEventArgs e)
{
    await DownloadAndRunScript("services/services.cmd");
}

private async Task DownloadAndRunScript(string githubPath)
{
    try
    {
        string baseUrl = "https://raw.githubusercontent.com/eroxftn910/EroxUTILITY-1.0/main/";
        string url = baseUrl + githubPath;

        using HttpClient client = new HttpClient();
        string scriptContent = await client.GetStringAsync(url);

        string tempPath = System.IO.Path.Combine(
            System.IO.Path.GetTempPath(),
            System.IO.Path.GetFileName(githubPath)
        );

        await File.WriteAllTextAsync(tempPath, scriptContent);

        ProcessStartInfo psi = new ProcessStartInfo
        {
            FileName = tempPath,
            UseShellExecute = true,
            Verb = "runas"
        };

        Process.Start(psi);
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
