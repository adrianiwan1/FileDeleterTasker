Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Size(430, 410)
$Form.Text = "Usuwanie plików starszych niż"
$Form.FormBorderStyle = 'Fixed3D'
$Form.AutoSize = $false
$Form.TopMost = $false

$MainTabControl = New-Object System.Windows.Forms.TabControl
$MainTabControl.Dock = 'Fill'
$Form.Controls.Add($MainTabControl)

# Main Tab
$MainTabPage = New-Object System.Windows.Forms.TabPage
$MainTabPage.Text = "Usuwanie plików"
$MainTabControl.TabPages.Add($MainTabPage)

# GroupBox Create Task
$groupBoxTworzenieZadania = New-Object System.Windows.Forms.GroupBox
$groupBoxTworzenieZadania.Text = "Tworzenie zadania usuwania"
$groupBoxTworzenieZadania.Location = New-Object System.Drawing.Point(10, 10)
$groupBoxTworzenieZadania.Size = New-Object System.Drawing.Size(400, 180)
$MainTabPage.Controls.Add($groupBoxTworzenieZadania)

# Label Lokalizacja
$labelLokalizacja = New-Object System.Windows.Forms.Label
$labelLokalizacja.Text = "Lokalizacja folderu:"
$labelLokalizacja.Location = New-Object System.Drawing.Point(20, 20)
$labelLokalizacja.AutoSize = $true
$groupBoxTworzenieZadania.Controls.Add($labelLokalizacja)

# Folder Browsing
$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowserDialog.SelectedPath = "C:\TotalControlParking\CCP_LPR\photo"
# Button browse
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

$groupBoxTworzenieZadania.Controls.Add($buttonBrowse)

#Textbox Lokalizacja
$textBoxLokalizacja = New-Object System.Windows.Forms.TextBox
$textBoxLokalizacja.ReadOnly = $false
$textBoxLokalizacja.Location = New-Object System.Drawing.Point(130, 40)
$textBoxLokalizacja.Size = New-Object System.Drawing.Size(250, 20)
$textBoxLokalizacja.Text = $folderBrowserDialog.SelectedPath
$groupBoxTworzenieZadania.Controls.Add($textBoxLokalizacja)

# Label picker
$labelPicker = New-Object System.Windows.Forms.Label
$labelPicker.Text = "Wybierz zadanie:"
$labelPicker.Location = New-Object System.Drawing.Point(20, 70)
$labelPicker.AutoSize = $true
$groupBoxTworzenieZadania.Controls.Add($labelPicker)

#Tabllica z zadaniami
$taskPathToTable = "\UsuwaniePlikow\*"
$printTasksToTable = Get-ScheduledTask -TaskPath $taskPathToTable | Select-Object -ExpandProperty TaskName
$taskTable=@()
foreach ($task in $printTasksToTable) {
    $taskTable += $task
}

#DropDown List zadanie
$DropDownListZadanie = New-Object System.Windows.Forms.ComboBox
$DropDownListZadanie.Location = New-Object System.Drawing.Size (20,90)
$DropDownListZadanie.Size = New-Object System.Drawing.Size(180,20)
$DropDownListZadanie.DropDownHeight = 200
$DropDownListZadanie.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDown
foreach ($zadanie in $taskTable) {
    $DropDownListZadanie.Items.Add($zadanie)
}
$groupBoxTworzenieZadania.Controls.Add($DropDownListZadanie)

# Label Godzina
$labelGodzina = New-Object System.Windows.Forms.Label
$labelGodzina.Text = "Godzina uruchamiania zadania:"
$labelGodzina.Location = New-Object System.Drawing.Point(220, 70)
$labelGodzina.AutoSize = $true
$groupBoxTworzenieZadania.Controls.Add($labelGodzina)

# Datetimepicker Godzina
$dateTimePickerGodzina = New-Object System.Windows.Forms.DateTimePicker
$dateTimePickerGodzina.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$dateTimePickerGodzina.CustomFormat = "HH:mm"
$dateTimePickerGodzina.ShowUpDown = $true
$dateTimePickerGodzina.Location = New-Object System.Drawing.Point(330, 90)
$dateTimePickerGodzina.Size = New-Object System.Drawing.Size(50, 30)
$groupBoxTworzenieZadania.Controls.Add($dateTimePickerGodzina)

#Label StarszeNiz
$labelStarszeNiz = New-Object System.Windows.Forms.Label
$labelStarszeNiz.Text = "Usuwać pliki starsze niż (w dniach, max 365):"
$labelStarszeNiz.Location = New-Object System.Drawing.Point(20, 120)
$labelStarszeNiz.AutoSize = $true
$groupBoxTworzenieZadania.Controls.Add($labelStarszeNiz)

#NumericUpDown StarszeNiz
$numericUpDownStarszeNiz = New-Object System.Windows.Forms.NumericUpDown
$numericUpDownStarszeNiz.Location = New-Object System.Drawing.Point(20, 140)
$numericUpDownStarszeNiz.Size = New-Object System.Drawing.Size(40, 20)
$numericUpDownStarszeNiz.Maximum = 365
$numericUpDownStarszeNiz.Minimum = 1
$numericUpDownStarszeNiz.Value = 7
$groupBoxTworzenieZadania.Controls.Add($numericUpDownStarszeNiz)

<#
# Radio Button "pliki .png, .jpg"
$radioButtonPngJpg = New-Object System.Windows.Forms.RadioButton
$radioButtonPngJpg.Text = "pliki .png .jpg"
$radioButtonPngJpg.Location = New-Object System.Drawing.Point(70, 90)
$radioButtonPngJpg.AutoSize = $true
$radioButtonPngJpg.Checked = $false
$groupBoxTworzenieZadania.Controls.Add($radioButtonPngJpg)

# Radio Button "pliki wszystko"
$radioButtonAllFiles = New-Object System.Windows.Forms.RadioButton
$radioButtonAllFiles.Text = "wszystkie pliki"
$radioButtonAllFiles.Location = New-Object System.Drawing.Point(160, 90)
$radioButtonAllFiles.AutoSize = $true
$radioButtonAllFiles.Checked = $true
$groupBoxTworzenieZadania.Controls.Add($radioButtonAllFiles)
#>

# Button DodajZdarzenie
$buttonDodajZdarzenie = New-Object System.Windows.Forms.Button
$buttonDodajZdarzenie.Location = New-Object System.Drawing.Point(280, 140)
$buttonDodajZdarzenie.Size = New-Object System.Drawing.Size(100, 30)
$buttonDodajZdarzenie.Text = "Dodaj zdarzenie"
$buttonDodajZdarzenie.Add_Click({
    $lokalizacja = $textBoxLokalizacja.Text
    $godzina = $dateTimePickerGodzina.Value.ToString("HH:mm")
    $starszeNiz = $numericUpDownStarszeNiz.Value * -1
    Write-Output $starszeNiz

# Tworzenie zadania w harmonogramie zadań

    $taskName = "Usuwanie starszych plików"
    $TaskNameDropDownList = $DropDownListZadanie.Text.ToString()
    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $TaskNameDropDownList }

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command `"Get-ChildItem '$lokalizacja' -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays($starszeNiz)  | Remove-Item -Force"
    $trigger = New-ScheduledTaskTrigger -Daily -At $godzina
    $settings = New-ScheduledTaskSettingsSet

    if($taskExists) {
        Set-ScheduledTask -TaskName $TaskNameDropDownList -Action $action -Trigger $trigger -TaskPath "UsuwaniePlikow" -Settings $settings
        [System.Windows.Forms.MessageBox]::Show("Zdarzenie zostało zaktualizowane.", "Informacja", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) 
    } else {
        try{
            Register-ScheduledTask -TaskName $TaskNameDropDownList -Action $action -Trigger $trigger -TaskPath "UsuwaniePlikow" -Settings $settings -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show("Zdarzenie usuwania zostało utworzone.", "Informacja", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
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

$groupBoxTworzenieZadania.Controls.Add($buttonDodajZdarzenie)

# Usuń pliki z wskazanej lokalizacji

# GroupBox Delete files
$groupBoxUsunPliki = New-Object System.Windows.Forms.GroupBox
$groupBoxUsunPliki.Text = "Usuwanie plików"
$groupBoxUsunPliki.Location = New-Object System.Drawing.Point(10, 200)
$groupBoxUsunPliki.Size = New-Object System.Drawing.Size(400, 180)
$MainTabPage.Controls.Add($groupBoxUsunPliki)

# Label Lokalizacja UPT
$labelLokalizacjaUPT = New-Object System.Windows.Forms.Label
$labelLokalizacjaUPT.Text = "Lokalizacja folderu:"
$labelLokalizacjaUPT.Location = New-Object System.Drawing.Point(20, 20)
$labelLokalizacjaUPT.AutoSize = $true
$groupBoxUsunPliki.Controls.Add($labelLokalizacjaUPT)


# Folder Browsing UPT
$folderBrowserDialogUPT = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowserDialogUPT.SelectedPath = "C:\TotalControlParking\CCP_LPR\photo"
# Button browse UPT
$buttonBrowseUPT = New-Object System.Windows.Forms.Button
$buttonBrowseUPT.Text = "Przeglądaj..."
$buttonBrowseUPT.Location = New-Object System.Drawing.Point(20, 40)
$buttonBrowseUPT.Size = New-Object System.Drawing.Size(100, 23)
$buttonBrowseUPT.Add_Click({
    $result = $folderBrowserDialogUPT.ShowDialog()
    if ($result -eq "OK") {
        $textBoxLokalizacjaUPT.Text = $folderBrowserDialogUPT.SelectedPath
    }
})

$groupBoxUsunPliki.Controls.Add($buttonBrowseUPT)

#Textbox LokalizacjaUPT
$textBoxLokalizacjaUPT = New-Object System.Windows.Forms.TextBox
$textBoxLokalizacjaUPT.ReadOnly = $false
$textBoxLokalizacjaUPT.Location = New-Object System.Drawing.Point(130, 40)
$textBoxLokalizacjaUPT.Size = New-Object System.Drawing.Size(250, 20)
$textBoxLokalizacjaUPT.Text = $folderBrowserDialogUPT.SelectedPath
$groupBoxUsunPliki.Controls.Add($textBoxLokalizacjaUPT)

#Label StarszeNizUPT
$labelStarszeNizUPT = New-Object System.Windows.Forms.Label
$labelStarszeNizUPT.Text = "Usuwać pliki starsze niż (w dniach, max 365):"
$labelStarszeNizUPT.Location = New-Object System.Drawing.Point(20, 70)
$labelStarszeNizUPT.AutoSize = $true
$groupBoxUsunPliki.Controls.Add($labelStarszeNizUPT)

#NumericUpDown StarszeNizUPT
$numericUpDownStarszeNizUPT = New-Object System.Windows.Forms.NumericUpDown
$numericUpDownStarszeNizUPT.Location = New-Object System.Drawing.Point(20,90)
$numericUpDownStarszeNizUPT.Size = New-Object System.Drawing.Size(40, 20)
$numericUpDownStarszeNizUPT.Maximum = 365
$numericUpDownStarszeNizUPT.Minimum = 1
$numericUpDownStarszeNizUPT.Value = 7
$groupBoxUsunPliki.Controls.Add($numericUpDownStarszeNizUPT)


# Radio Button "pliki .png, .jpg"
$radioButtonPngJpgUPT = New-Object System.Windows.Forms.RadioButton
$radioButtonPngJpgUPT.Text = "pliki .png .jpg"
$radioButtonPngJpgUPT.Location = New-Object System.Drawing.Point(70, 90)
$radioButtonPngJpgUPT.AutoSize = $true
$radioButtonPngJpgUPT.Checked = $false
$groupBoxUsunPliki.Controls.Add($radioButtonPngJpgUPT)

# Radio Button "pliki wszystko"
$radioButtonAllFilesUPT = New-Object System.Windows.Forms.RadioButton
$radioButtonAllFilesUPT.Text = "wszystkie pliki"
$radioButtonAllFilesUPT.Location = New-Object System.Drawing.Point(160, 90)
$radioButtonAllFilesUPT.AutoSize = $true
$radioButtonAllFilesUPT.Checked = $true
$groupBoxUsunPliki.Controls.Add($radioButtonAllFilesUPT)

$selectTypeFilesUPT = {
    $lokalizacjaUPT = $textBoxLokalizacjaUPT.Text
    $starszeNizUPT = $numericUpDownStarszeNizUPT.Value * -1
    if($radioButtonPngJpgUPT.Checked)
    {
       try{ 
            Get-ChildItem $lokalizacjaUPT -include *.jpg, *.png -Recurse -ErrorAction Stop -ErrorVariable FileErrors| Where-Object CreationTime -lt  (Get-Date).AddDays($starszeNizUPT) | Out-GridView
       }
       catch{
        [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacjaUPT  + " nie istnieje",
        "Błąd",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error)
       }
    }elseif($radioButtonAllFilesUPT.Checked)
    {   
        try{
            Get-ChildItem $lokalizacjaUPT -Recurse -ErrorAction Stop -ErrorVariable FileErrors| Where-Object CreationTime -lt  (Get-Date).AddDays($starszeNizUPT) | Out-GridView 
        }
        catch{
                [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacjaUPT  + " nie istnieje",
                "Błąd",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

#Button Pokaz plik
$buttonShowFilesUPT = New-Object System.Windows.Forms.Button
$buttonShowFilesUPT.Location = New-Object System.Drawing.Point(20, 140)
$buttonShowFilesUPT.Size = New-Object System.Drawing.Size(100, 30)
$buttonShowFilesUPT.Text = "Pokaż pliki"
$buttonShowFilesUPT.Add_Click($selectTypeFilesUPT)
$groupBoxUsunPliki.Controls.Add($buttonShowFilesUPT)


#Button Usuń teraz
$buttonUsunTeraz = New-Object System.Windows.Forms.Button
$buttonUsunTeraz.Location = New-Object System.Drawing.Point(280, 140)
$buttonUsunTeraz.Size = New-Object System.Drawing.Size(100, 30)
$buttonUsunTeraz.Text = "Usuń pliki"
$buttonUsunTeraz.Add_Click({

    $lokalizacjaUPT = $textBoxLokalizacjaUPT.Text
    $starszeNizUPT = $numericUpDownStarszeNizUPT.Value * -1

    if($radioButtonPngJpgUPT.Checked)
    {
       try{ 
            Get-ChildItem $lokalizacjaUPT+"\*" -include *.jpg, *.png -File -Recurse -ErrorAction Stop| Where-Object CreationTime -lt  (Get-Date).AddDays($starszeNizUPT) | Remove-Item -Force
       }
       catch{
        [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacjaUPT  + " nie istnieje",
        "Błąd",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error)
       }
    }elseif($radioButtonAllFilesUPT.Checked)
    {   
        try{
            Get-ChildItem $lokalizacjaUPT+"\*" -Recurse -File -ErrorAction Stop| Where-Object CreationTime -lt  (Get-Date).AddDays($starszeNizUPT) | Remove-Item -Force
        }
        catch{
                [System.Windows.Forms.MessageBox]::Show("Folder " + $lokalizacjaUPT  + " nie istnieje",
                "Błąd",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

$groupBoxUsunPliki.Controls.Add($buttonUsunTeraz)


 #Button Anuluj
<#
$buttonAnuluj = New-Object System.Windows.Forms.Button
$buttonAnuluj.Location = New-Object System.Drawing.Point(170, 140)
$buttonAnuluj.Size = New-Object System.Drawing.Size(100, 30)
$buttonAnuluj.Text = "Anuluj"
$buttonAnuluj.Add_Click({
    $Form.Close()
})
$groupBoxUsunPliki.Controls.Add($buttonAnuluj)
#>

[void]$Form.ShowDialog()
