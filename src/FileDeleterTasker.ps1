Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Size(400, 250)
$Form.Text = "Usuwanie plików starszych niż"
$Form.TopMost = $false

$labelLokalizacja = New-Object System.Windows.Forms.Label
$labelLokalizacja.Text = "Lokalizacja folderu:"
$labelLokalizacja.Location = New-Object System.Drawing.Point(20, 20)
$labelLokalizacja.AutoSize = $true
$Form.Controls.Add($labelLokalizacja)

$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowserDialog.SelectedPath = "C:\TotalControlParking\CCP_LPR\photo"
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Przeglądaj..."
$buttonBrowse.Location = New-Object System.Drawing.Point(20, 40)
$buttonBrowse.Size = New-Object System.Drawing.Size(100, 23)
$buttonBrowse.Add_Click({
    $result = $folderBrowserDialog.ShowDialog()
    if ($result -eq "OK") {
        $textBoxLokalizacja.Text = $folderBrowserDialog.SelectedPath
    }
})

$Form.Controls.Add($buttonBrowse)

$textBoxLokalizacja = New-Object System.Windows.Forms.TextBox
$textBoxLokalizacja.ReadOnly = $true
$textBoxLokalizacja.Location = New-Object System.Drawing.Point(130, 40)
$textBoxLokalizacja.Size = New-Object System.Drawing.Size(250, 20)
$textBoxLokalizacja.Text = $folderBrowserDialog.SelectedPath
$Form.Controls.Add($textBoxLokalizacja)

$labelGodzina = New-Object System.Windows.Forms.Label
$labelGodzina.Text = "Godzina uruchamiania zadania:"
$labelGodzina.Location = New-Object System.Drawing.Point(20, 70)
$labelGodzina.AutoSize = $true
$Form.Controls.Add($labelGodzina)

$dateTimePickerGodzina = New-Object System.Windows.Forms.DateTimePicker
$dateTimePickerGodzina.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$dateTimePickerGodzina.CustomFormat = "HH:mm"
$dateTimePickerGodzina.ShowUpDown = $true
$dateTimePickerGodzina.Location = New-Object System.Drawing.Point(20, 90)
$dateTimePickerGodzina.Size = New-Object System.Drawing.Size(50, 30)
$Form.Controls.Add($dateTimePickerGodzina)


$labelStarszeNiz = New-Object System.Windows.Forms.Label
$labelStarszeNiz.Text = "Usuwać pliki starsze niż (w dniach, max 365):"
$labelStarszeNiz.Location = New-Object System.Drawing.Point(20, 120)
$labelStarszeNiz.AutoSize = $true
$Form.Controls.Add($labelStarszeNiz)

$numericUpDownStarszeNiz = New-Object System.Windows.Forms.NumericUpDown
$numericUpDownStarszeNiz.Location = New-Object System.Drawing.Point(20, 140)
$numericUpDownStarszeNiz.Size = New-Object System.Drawing.Size(40, 20)
$numericUpDownStarszeNiz.Maximum = 365
$numericUpDownStarszeNiz.Minimum = 1
$numericUpDownStarszeNiz.Value = 7
$Form.Controls.Add($numericUpDownStarszeNiz)

$buttonDodajZdarzenie = New-Object System.Windows.Forms.Button
$buttonDodajZdarzenie.Location = New-Object System.Drawing.Point(20, 180)
$buttonDodajZdarzenie.Size = New-Object System.Drawing.Size(100, 30)
$buttonDodajZdarzenie.Text = "Dodaj zdarzenie"
$buttonDodajZdarzenie.Add_Click({
    $lokalizacja = $textBoxLokalizacja.Text
    $godzina = $dateTimePickerGodzina.Value.ToString("HH:mm")
    $starszeNiz = $numericUpDownStarszeNiz.Value * -1
    Write-Output $starszeNiz

    # Tworzenie zadania w harmonogramie zadań

    $taskName = "Usuwanie starszych plików"
    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command `"Get-ChildItem '$lokalizacja' -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays($starszeNiz)  | Remove-Item -Force"
    $trigger = New-ScheduledTaskTrigger -Daily -At $godzina
    $settings = New-ScheduledTaskSettingsSet

    if($taskExists) {
    Set-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -TaskPath "UsuwaniePlikow" -Settings $settings
    [System.Windows.Forms.MessageBox]::Show("Zdarzenie zostało zaktualizowane.", "Informacja", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) 
    } else {
        try{
            Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -TaskPath "UsuwaniePlikow" -Settings $settings -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show("Zdarzenie usuwania zostało ustawione.", "Informacja", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch
        {
            [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacja  + " nie istnieje",
            "Błąd",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

$Form.Controls.Add($buttonDodajZdarzenie)

# Usuń pliki z wskazanej lokalizacji

$buttonUsunTeraz = New-Object System.Windows.Forms.Button
$buttonUsunTeraz.Location = New-Object System.Drawing.Point(130, 180)
$buttonUsunTeraz.Size = New-Object System.Drawing.Size(100, 30)
$buttonUsunTeraz.Text = "Usuń pliki"
$buttonUsunTeraz.Add_Click({

    $lokalizacja = $textBoxLokalizacja.Text
    $starszeNiz = $numericUpDownStarszeNiz.Value * -1

    try{
    
        Get-ChildItem $lokalizacja -include *.jpg -Recurse -File  -ErrorAction Stop| Where CreationTime -lt  (Get-Date).AddDays($starszeNiz) #| Remove-Item -Force
    }
    catch
    {
        [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacja  + " nie istnieje",
        "Błąd",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error)
    }
 
})

$Form.Controls.Add($buttonUsunTeraz)

$buttonAnuluj = New-Object System.Windows.Forms.Button
$buttonAnuluj.Location = New-Object System.Drawing.Point(280, 180)
$buttonAnuluj.Size = New-Object System.Drawing.Size(100, 30)
$buttonAnuluj.Text = "Anuluj"
$buttonAnuluj.Add_Click({
    $Form.Close()
})
$Form.Controls.Add($buttonAnuluj)

[void]$Form.ShowDialog()
