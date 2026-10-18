<#
    AZERON TOOL BOX
    Modern WPF software installer for Windows (uses winget).
    Single file, no extra downloads - the UI opens instantly.

    Run:  powershell -ExecutionPolicy Bypass -File .\AzeronToolBox.ps1
    Or host the file and run:  irm <your-raw-url>/AzeronToolBox.ps1 | iex
#>

$main = {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

    # ------------------------------------------------------------------
    # CATALOG  (Category|Name|winget ID)  - add or remove lines freely
    # ------------------------------------------------------------------
    $catalog = @(
        'Browsers|Google Chrome|Google.Chrome'
        'Browsers|Mozilla Firefox|Mozilla.Firefox'
        'Browsers|Brave|Brave.Brave'
        'Browsers|Opera GX|Opera.OperaGX'
        'Browsers|Vivaldi|Vivaldi.Vivaldi'
        'Communication|Discord|Discord.Discord'
        'Communication|Telegram|Telegram.TelegramDesktop'
        'Communication|Signal|OpenWhisperSystems.Signal'
        'Communication|Slack|SlackTechnologies.Slack'
        'Communication|Zoom|Zoom.Zoom'
        'Communication|Microsoft Teams|Microsoft.Teams'
        'Gaming|Steam|Valve.Steam'
        'Gaming|Epic Games Launcher|EpicGames.EpicGamesLauncher'
        'Gaming|GOG Galaxy|GOG.Galaxy'
        'Gaming|EA app|ElectronicArts.EADesktop'
        'Gaming|Ubisoft Connect|Ubisoft.Connect'
        'Gaming|Battle.net|Blizzard.BattleNet'
        'Media|VLC|VideoLAN.VLC'
        'Media|Spotify|Spotify.Spotify'
        'Media|OBS Studio|OBSProject.OBSStudio'
        'Media|Audacity|Audacity.Audacity'
        'Media|HandBrake|HandBrake.HandBrake'
        'Media|MPC-HC|clsid2.mpc-hc'
        'Development|Visual Studio Code|Microsoft.VisualStudioCode'
        'Development|Git|Git.Git'
        'Development|GitHub Desktop|GitHub.GitHubDesktop'
        'Development|Python 3.13|Python.Python.3.13'
        'Development|Node.js LTS|OpenJS.NodeJS.LTS'
        'Development|Notepad++|Notepad++.Notepad++'
        'Development|Windows Terminal|Microsoft.WindowsTerminal'
        'Development|PowerShell 7|Microsoft.PowerShell'
        'Development|Docker Desktop|Docker.DockerDesktop'
        'Development|Postman|Postman.Postman'
        'Utilities|7-Zip|7zip.7zip'
        'Utilities|WinRAR|RARLab.WinRAR'
        'Utilities|PowerToys|Microsoft.PowerToys'
        'Utilities|Everything|voidtools.Everything'
        'Utilities|ShareX|ShareX.ShareX'
        'Utilities|Rufus|Rufus.Rufus'
        'Utilities|qBittorrent|qBittorrent.qBittorrent'
        'Utilities|AnyDesk|AnyDeskSoftwareGmbH.AnyDesk'
        'Utilities|TeamViewer|TeamViewer.TeamViewer'
        'Utilities|SumatraPDF|SumatraPDF.SumatraPDF'
        'Utilities|Adobe Acrobat Reader|Adobe.Acrobat.Reader.64-bit'
        'Utilities|Bitwarden|Bitwarden.Bitwarden'
        'System|CPU-Z|CPUID.CPU-Z'
        'System|HWiNFO|REALiX.HWiNFO'
        'System|Wireshark|WiresharkFoundation.Wireshark'
        'System|Malwarebytes|Malwarebytes.Malwarebytes'
        'System|Proton VPN|Proton.ProtonVPN'
        'Creative|GIMP|GIMP.GIMP'
        'Creative|Blender|BlenderFoundation.Blender'
        'Creative|Inkscape|Inkscape.Inkscape'
        'Creative|Krita|KDE.Krita'
        'Creative|Paint.NET|dotPDN.PaintDotNet'
        'Creative|Figma|Figma.Figma'
    )

    # ------------------------------------------------------------------
    # THEMES
    # ------------------------------------------------------------------
    $themes = [ordered]@{
        'Midnight' = @{ Bg='#0F1220'; Surface='#151932'; Card='#1B2040'; CardHover='#242A52'; Text='#EEF1FF'; Sub='#8B93B8'; Accent='#6C8CFF'; AccentText='#0B1030'; Line='#2A3052' }
        'Light'    = @{ Bg='#F4F6FB'; Surface='#FFFFFF'; Card='#FFFFFF'; CardHover='#EEF2FF'; Text='#1A2038'; Sub='#6B7391'; Accent='#4F6BED'; AccentText='#FFFFFF'; Line='#DCE1F0' }
        'Violet'   = @{ Bg='#130B22'; Surface='#1A1030'; Card='#22163D'; CardHover='#2D1E52'; Text='#F3EBFF'; Sub='#A592C8'; Accent='#B26BFF'; AccentText='#1A0B30'; Line='#35244F' }
        'Emerald'  = @{ Bg='#08140F'; Surface='#0D1D16'; Card='#12281E'; CardHover='#183629'; Text='#E8FFF4'; Sub='#7FB09A'; Accent='#2EE59D'; AccentText='#04150D'; Line='#1E3B2D' }
        'Sunset'   = @{ Bg='#1A0F0C'; Surface='#241510'; Card='#2E1B15'; CardHover='#3B241C'; Text='#FFF1EA'; Sub='#BC9484'; Accent='#FF7A45'; AccentText='#2A0E04'; Line='#4A2D23' }
        'Carbon'   = @{ Bg='#0C0C0D'; Surface='#131315'; Card='#1A1A1D'; CardHover='#232327'; Text='#F2F2F3'; Sub='#8D8D95'; Accent='#E8E8EC'; AccentText='#111113'; Line='#2A2A2F' }
    }
    $themeMap = @{ Bg='BgBrush'; Surface='SurfaceBrush'; Card='CardBrush'; CardHover='CardHoverBrush'; Text='TextBrush'; Sub='SubTextBrush'; Accent='AccentBrush'; AccentText='AccentTextBrush'; Line='LineBrush' }

    # ------------------------------------------------------------------
    # XAML
    # ------------------------------------------------------------------
    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Azeron Tool Box" Width="1120" Height="740" WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanMinimize" FontFamily="Segoe UI" UseLayoutRounding="True">
  <Window.Resources>
    <SolidColorBrush x:Key="BgBrush" Color="#0F1220"/>
    <SolidColorBrush x:Key="SurfaceBrush" Color="#151932"/>
    <SolidColorBrush x:Key="CardBrush" Color="#1B2040"/>
    <SolidColorBrush x:Key="CardHoverBrush" Color="#242A52"/>
    <SolidColorBrush x:Key="TextBrush" Color="#EEF1FF"/>
    <SolidColorBrush x:Key="SubTextBrush" Color="#8B93B8"/>
    <SolidColorBrush x:Key="AccentBrush" Color="#6C8CFF"/>
    <SolidColorBrush x:Key="AccentTextBrush" Color="#0B1030"/>
    <SolidColorBrush x:Key="LineBrush" Color="#2A3052"/>

    <!-- Thin modern vertical scrollbar -->
    <Style TargetType="ScrollBar">
      <Setter Property="Width" Value="8"/>
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ScrollBar">
            <Track x:Name="PART_Track" IsDirectionReversed="True">
              <Track.Thumb>
                <Thumb>
                  <Thumb.Template>
                    <ControlTemplate TargetType="Thumb">
                      <Border CornerRadius="4" Background="{DynamicResource SubTextBrush}" Opacity="0.45" Margin="1,0"/>
                    </ControlTemplate>
                  </Thumb.Template>
                </Thumb>
              </Track.Thumb>
            </Track>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Buttons -->
    <Style x:Key="PillBase" TargetType="Button">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="10" Padding="16,9">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"
                                TextElement.Foreground="{TemplateBinding Foreground}"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="Opacity" Value="0.85"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter TargetName="bd" Property="Opacity" Value="0.35"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="PrimaryBtn" TargetType="Button" BasedOn="{StaticResource PillBase}">
      <Setter Property="Background" Value="{DynamicResource AccentBrush}"/>
      <Setter Property="Foreground" Value="{DynamicResource AccentTextBrush}"/>
    </Style>
    <Style x:Key="GhostBtn" TargetType="Button" BasedOn="{StaticResource PillBase}">
      <Setter Property="Background" Value="{DynamicResource CardBrush}"/>
      <Setter Property="Foreground" Value="{DynamicResource TextBrush}"/>
    </Style>

    <!-- Theme swatch -->
    <Style x:Key="SwatchBtn" TargetType="Button">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Margin" Value="4,0"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Width="22" Height="22" CornerRadius="11" Background="{TemplateBinding Background}"
                    BorderBrush="{DynamicResource TextBrush}" BorderThickness="0"/>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="BorderThickness" Value="2"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Sidebar category button -->
    <Style x:Key="NavBtn" TargetType="RadioButton">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="RadioButton">
            <Border x:Name="bd" Background="Transparent" CornerRadius="10" Padding="14,10" Margin="0,2">
              <Grid>
                <Border x:Name="bar" Width="3" Height="16" CornerRadius="2" HorizontalAlignment="Left"
                        Background="{DynamicResource AccentBrush}" Visibility="Collapsed" Margin="-8,0,0,0"/>
                <TextBlock x:Name="tx" Text="{TemplateBinding Content}" FontSize="13" FontWeight="SemiBold"
                           Foreground="{DynamicResource SubTextBrush}"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="Background" Value="{DynamicResource CardBrush}"/></Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="bd" Property="Background" Value="{DynamicResource CardBrush}"/>
                <Setter TargetName="tx" Property="Foreground" Value="{DynamicResource TextBrush}"/>
                <Setter TargetName="bar" Property="Visibility" Value="Visible"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- App card (CheckBox) -->
    <Style x:Key="AppCard" TargetType="CheckBox">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="190"/>
      <Setter Property="Height" Value="64"/>
      <Setter Property="Margin" Value="6"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="CheckBox">
            <Border x:Name="bd" Background="{DynamicResource CardBrush}" BorderBrush="{DynamicResource LineBrush}"
                    BorderThickness="1.5" CornerRadius="12" Padding="14,10">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel VerticalAlignment="Center">
                  <TextBlock Text="{TemplateBinding Content}" Foreground="{DynamicResource TextBrush}"
                             FontWeight="SemiBold" FontSize="13" TextTrimming="CharacterEllipsis"/>
                  <TextBlock Text="{TemplateBinding Tag}" Foreground="{DynamicResource SubTextBrush}"
                             FontSize="11" Margin="0,2,0,0"/>
                </StackPanel>
                <Border x:Name="ck" Grid.Column="1" Width="20" Height="20" CornerRadius="10" BorderThickness="1.5"
                        BorderBrush="{DynamicResource LineBrush}" Margin="8,0,0,0">
                  <Path x:Name="tick" Data="M5,10 L8.5,13.5 L14.5,6.5" Stroke="{DynamicResource AccentTextBrush}"
                        StrokeThickness="2" Visibility="Collapsed"/>
                </Border>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="Background" Value="{DynamicResource CardHoverBrush}"/></Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="bd" Property="BorderBrush" Value="{DynamicResource AccentBrush}"/>
                <Setter TargetName="ck" Property="Background" Value="{DynamicResource AccentBrush}"/>
                <Setter TargetName="ck" Property="BorderBrush" Value="{DynamicResource AccentBrush}"/>
                <Setter TargetName="tick" Property="Visibility" Value="Visible"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border Margin="14" CornerRadius="16" Background="{DynamicResource BgBrush}"
          BorderBrush="{DynamicResource LineBrush}" BorderThickness="1">
    <Border.Effect><DropShadowEffect BlurRadius="24" ShadowDepth="0" Opacity="0.5"/></Border.Effect>
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="64"/>
        <RowDefinition Height="*"/>
      </Grid.RowDefinitions>

      <!-- Title bar -->
      <Grid x:Name="TitleBar" Background="Transparent" Margin="22,0,14,0">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
          <Border Width="34" Height="34" CornerRadius="10" Background="{DynamicResource AccentBrush}">
            <TextBlock Text="A" FontSize="18" FontWeight="Black" Foreground="{DynamicResource AccentTextBrush}"
                       HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Border>
          <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
            <TextBlock Text="AZERON TOOL BOX" FontSize="15" FontWeight="Bold" Foreground="{DynamicResource TextBrush}"/>
            <TextBlock Text="Install your favorite software in one click" FontSize="11" Foreground="{DynamicResource SubTextBrush}"/>
          </StackPanel>
        </StackPanel>
        <StackPanel x:Name="Themes" Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,18,0"/>
        <StackPanel Grid.Column="3" Orientation="Horizontal" VerticalAlignment="Center">
          <Button x:Name="BtnMin" Style="{StaticResource GhostBtn}" Content="&#x2014;" Padding="0" Width="34" Height="30" Margin="0,0,6,0"/>
          <Button x:Name="BtnClose" Style="{StaticResource GhostBtn}" Content="&#x2715;" Padding="0" Width="34" Height="30"/>
        </StackPanel>
      </Grid>

      <!-- Body -->
      <Grid Grid.Row="1">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="220"/>
          <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Border Background="{DynamicResource SurfaceBrush}" CornerRadius="0,0,0,16" Padding="16,18">
          <DockPanel>
            <TextBlock x:Name="AdminInfo" DockPanel.Dock="Bottom" TextWrapping="Wrap" FontSize="11"
                       Foreground="{DynamicResource SubTextBrush}" Margin="4,10,4,0"/>
            <StackPanel>
              <TextBlock Text="CATEGORIES" FontSize="11" FontWeight="Bold" Foreground="{DynamicResource SubTextBrush}" Margin="14,0,0,8"/>
              <StackPanel x:Name="Nav"/>
            </StackPanel>
          </DockPanel>
        </Border>

        <Grid Grid.Column="1" Margin="22,16,22,18">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="130"/>
          </Grid.RowDefinitions>

          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <Border Background="{DynamicResource CardBrush}" CornerRadius="10" Height="40" Padding="14,0">
              <Grid>
                <TextBox x:Name="Search" BorderThickness="0" Background="Transparent" FontSize="14"
                         Foreground="{DynamicResource TextBrush}" CaretBrush="{DynamicResource TextBrush}"
                         VerticalContentAlignment="Center"/>
                <TextBlock x:Name="SearchHint" Text="Search apps..." IsHitTestVisible="False" FontSize="14"
                           Foreground="{DynamicResource SubTextBrush}" VerticalAlignment="Center" Margin="2,0,0,0"/>
              </Grid>
            </Border>
            <StackPanel Grid.Column="1" Orientation="Horizontal" Margin="12,0,0,0">
              <Button x:Name="BtnAll" Style="{StaticResource GhostBtn}" Content="Select all" Margin="0,0,8,0"/>
              <Button x:Name="BtnNone" Style="{StaticResource GhostBtn}" Content="Clear" Margin="0,0,8,0"/>
              <Button x:Name="BtnInstall" Style="{StaticResource PrimaryBtn}" Content="Install selected (0)" IsEnabled="False"/>
            </StackPanel>
          </Grid>

          <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled" Margin="-6,12,0,0">
            <WrapPanel x:Name="CardPanel"/>
          </ScrollViewer>

          <StackPanel Grid.Row="2" Margin="0,10,0,0">
            <TextBlock x:Name="Status" Text="Ready." FontSize="12" Foreground="{DynamicResource SubTextBrush}"/>
            <ProgressBar x:Name="Progress" IsIndeterminate="True" Height="4" Margin="0,6,0,0" BorderThickness="0"
                         Foreground="{DynamicResource AccentBrush}" Background="{DynamicResource CardBrush}" Visibility="Collapsed"/>
          </StackPanel>

          <Border Grid.Row="3" Margin="0,10,0,0" Background="{DynamicResource SurfaceBrush}" CornerRadius="10">
            <TextBox x:Name="Log" IsReadOnly="True" BorderThickness="0" Background="Transparent" Padding="10"
                     FontFamily="Consolas" FontSize="12" Foreground="{DynamicResource SubTextBrush}"
                     VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
          </Border>
        </Grid>
      </Grid>
    </Grid>
  </Border>
</Window>
'@

    # ------------------------------------------------------------------
    # Build window
    # ------------------------------------------------------------------
    [xml]$xml = $xaml
    $win = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xml))

    $ui = @{}
    foreach ($n in 'TitleBar','BtnMin','BtnClose','Themes','Nav','CardPanel','Search','SearchHint','BtnAll','BtnNone','BtnInstall','Log','Progress','Status','AdminInfo') {
        $ui[$n] = $win.FindName($n)
    }
    $ctx = @{ Cards = New-Object System.Collections.ArrayList; Cat = 'All'; Busy = $false }
    $bc  = New-Object Windows.Media.BrushConverter

    # Admin info
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $ui.AdminInfo.Text = if ($isAdmin) { 'Running as Administrator' } else { 'Standard user - some installers will ask for admin (UAC).' }

    # Window chrome
    $ui.TitleBar.Add_MouseLeftButtonDown({ try { $win.DragMove() } catch {} }.GetNewClosure())
    $ui.BtnMin.Add_Click({ $win.WindowState = 'Minimized' }.GetNewClosure())
    $ui.BtnClose.Add_Click({ $win.Close() }.GetNewClosure())

    # Refresh (filter + counters)
    $ctx.Refresh = {
        $term = $ui.Search.Text.Trim()
        $count = 0
        foreach ($c in $ctx.Cards) {
            $app   = $c.DataContext
            $okCat = ($ctx.Cat -eq 'All') -or ($app.Cat -eq $ctx.Cat)
            $okTxt = (-not $term) -or ($app.Name -like "*$term*")
            $c.Visibility = if ($okCat -and $okTxt) { 'Visible' } else { 'Collapsed' }
            if ($c.IsChecked) { $count++ }
        }
        $ui.BtnInstall.Content   = "Install selected ($count)"
        $ui.BtnInstall.IsEnabled = ($count -gt 0) -and (-not $ctx.Busy)
    }
    $ctx.OnToggle = { & $ctx.Refresh }.GetNewClosure()

    # Theme switcher
    $ctx.ApplyTheme = {
        param($name)
        $t = $themes[$name]
        if (-not $t) { return }
        foreach ($k in $themeMap.Keys) { $win.Resources[$themeMap[$k]] = $bc.ConvertFromString($t[$k]) }
        try {
            $dir = Join-Path $env:APPDATA 'AzeronToolBox'
            if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
            Set-Content -Path (Join-Path $dir 'theme.txt') -Value $name
        } catch {}
    }.GetNewClosure()

    foreach ($name in $themes.Keys) {
        $b = New-Object Windows.Controls.Button
        $b.Style      = $win.FindResource('SwatchBtn')
        $b.Background = $bc.ConvertFromString($themes[$name].Accent)
        $b.ToolTip    = $name
        $b.Tag        = $name
        $b.Add_Click({ param($s, $e) & $ctx.ApplyTheme $s.Tag }.GetNewClosure())
        [void]$ui.Themes.Children.Add($b)
    }
    try {
        $saved = (Get-Content (Join-Path $env:APPDATA 'AzeronToolBox\theme.txt') -ErrorAction Stop | Select-Object -First 1).Trim()
        if ($themes.Contains($saved)) { & $ctx.ApplyTheme $saved }
    } catch {}

    # App cards
    $cardStyle = $win.FindResource('AppCard')
    foreach ($line in $catalog) {
        $p  = $line.Split('|')
        $cb = New-Object Windows.Controls.CheckBox
        $cb.Style       = $cardStyle
        $cb.Content     = $p[1]
        $cb.Tag         = $p[0]
        $cb.DataContext = [pscustomobject]@{ Cat = $p[0]; Name = $p[1]; Id = $p[2] }
        $cb.Add_Checked($ctx.OnToggle)
        $cb.Add_Unchecked($ctx.OnToggle)
        [void]$ctx.Cards.Add($cb)
        [void]$ui.CardPanel.Children.Add($cb)
    }

    # Category navigation
    $cats = @('All') + ($catalog | ForEach-Object { $_.Split('|')[0] } | Select-Object -Unique)
    $navStyle = $win.FindResource('NavBtn')
    foreach ($c in $cats) {
        $rb = New-Object Windows.Controls.RadioButton
        $rb.Style     = $navStyle
        $rb.Content   = $c
        $rb.Tag       = $c
        $rb.GroupName = 'nav'
        $rb.Add_Checked({ param($s, $e) $ctx.Cat = $s.Tag; & $ctx.Refresh }.GetNewClosure())
        [void]$ui.Nav.Children.Add($rb)
    }
    $ui.Nav.Children[0].IsChecked = $true

    # Search
    $ui.Search.Add_TextChanged({
        $ui.SearchHint.Visibility = if ($ui.Search.Text) { 'Collapsed' } else { 'Visible' }
        & $ctx.Refresh
    }.GetNewClosure())

    # Select all / clear (visible cards only)
    $ui.BtnAll.Add_Click({  foreach ($c in $ctx.Cards) { if ($c.Visibility -eq 'Visible') { $c.IsChecked = $true } } }.GetNewClosure())
    $ui.BtnNone.Add_Click({ foreach ($c in $ctx.Cards) { $c.IsChecked = $false } }.GetNewClosure())

    # Log pump (UI thread)
    $ctx.Timer = New-Object Windows.Threading.DispatcherTimer
    $ctx.Timer.Interval = [TimeSpan]::FromMilliseconds(200)
    $ctx.Timer.Add_Tick({
        $line = $null
        $done = $false
        while ($ctx.Queue -and $ctx.Queue.TryDequeue([ref]$line)) {
            if ($line -eq '::DONE::') { $done = $true; continue }
            if ($line.StartsWith('>>')) { $ui.Status.Text = $line.Substring(2).Trim() }
            $ui.Log.AppendText($line + "`r`n")
        }
        $ui.Log.ScrollToEnd()
        if ($done) {
            $ctx.Timer.Stop()
            $ctx.Busy = $false
            $ui.Progress.Visibility = 'Collapsed'
            try { $ctx.PS.Dispose(); $ctx.RS.Dispose() } catch {}
            & $ctx.Refresh
        }
    }.GetNewClosure())

    # Install
    $ui.BtnInstall.Add_Click({
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            [void][Windows.MessageBox]::Show('winget was not found. Install "App Installer" from the Microsoft Store, then try again.', 'Azeron Tool Box', 'OK', 'Warning')
            return
        }
        $items = @($ctx.Cards | Where-Object { $_.IsChecked } | ForEach-Object { $_.DataContext })
        if ($items.Count -eq 0) { return }

        $ctx.Busy = $true
        & $ctx.Refresh
        $ui.Progress.Visibility = 'Visible'
        $ui.Log.Clear()
        $ctx.Queue = New-Object 'System.Collections.Concurrent.ConcurrentQueue[string]'

        $ctx.RS = [runspacefactory]::CreateRunspace()
        $ctx.RS.Open()
        $ctx.PS = [powershell]::Create()
        $ctx.PS.Runspace = $ctx.RS

        $worker = {
            param($items, $q)
            [Console]::OutputEncoding = [Text.Encoding]::UTF8
            $blocks = '[' + [char]0x2588 + [char]0x2592 + ']'
            $i = 0; $ok = 0; $fail = 0
            foreach ($a in $items) {
                $i++
                $q.Enqueue(">> [$i/$($items.Count)] Installing $($a.Name)...")
                $code = 0
                try {
                    & winget install --id $a.Id -e --silent --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 |
                        ForEach-Object {
                            $t = "$_".Trim()
                            if ($t.Length -gt 3 -and $t -notmatch $blocks -and $t -notmatch '\d\s*(KB|MB|GB)\s*/') { $q.Enqueue("   $t") }
                        }
                    $code = $LASTEXITCODE
                } catch {
                    $code = -1
                    $q.Enqueue("   $_")
                }
                # 0 = ok, -1978335189 = already up to date, -1978335135 = already installed
                if ($code -eq 0 -or $code -eq -1978335189 -or $code -eq -1978335135) {
                    $ok++;  $q.Enqueue("[OK]   $($a.Name)")
                } else {
                    $fail++; $q.Enqueue("[FAIL] $($a.Name) (exit code $code)")
                }
            }
            $q.Enqueue(">> Finished: $ok succeeded, $fail failed")
            $q.Enqueue('::DONE::')
        }

        [void]$ctx.PS.AddScript($worker.ToString()).AddArgument($items).AddArgument($ctx.Queue)
        [void]$ctx.PS.BeginInvoke()
        $ctx.Timer.Start()
    }.GetNewClosure())

    $ui.Log.AppendText("Welcome to Azeron Tool Box.`r`nPick the apps you want and press 'Install selected'.`r`n")
    [void]$win.ShowDialog()
}

# WPF needs an STA thread. Windows PowerShell 5.1 is STA by default; PowerShell 7 is not.
if ([Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA') {
    & $main
} else {
    $rs = [runspacefactory]::CreateRunspace()
    $rs.ApartmentState = 'STA'
    $rs.ThreadOptions  = 'ReuseThread'
    $rs.Open()
    $ps = [powershell]::Create()
    $ps.Runspace = $rs
    [void]$ps.AddScript($main.ToString())
    [void]$ps.Invoke()
    if ($ps.HadErrors) { $ps.Streams.Error | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
    $rs.Close()
}
