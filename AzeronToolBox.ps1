<#
    AZERON TOOL BOX
    Modern WPF software installer for Windows (uses winget).
    Single file - the UI opens instantly; app icons load in the background
    and are cached in %APPDATA%\AzeronToolBox\icons.

    Run:  powershell -ExecutionPolicy Bypass -File .\AzeronToolBox.ps1
    Or:   irm <your-raw-url>/AzeronToolBox.ps1 | iex
#>

$main = {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

    # ------------------------------------------------------------------
    # CATALOG  (Category|Name|winget ID|website for the icon)
    # ------------------------------------------------------------------
    $catalog = @(
        'Browsers|Google Chrome|Google.Chrome|google.com/chrome'
        'Browsers|Mozilla Firefox|Mozilla.Firefox|firefox.com'
        'Browsers|Brave|Brave.Brave|brave.com'
        'Browsers|Opera GX|Opera.OperaGX|opera.com/gx'
        'Browsers|Vivaldi|Vivaldi.Vivaldi|vivaldi.com'
        'Communication|Discord|Discord.Discord|discord.com'
        'Communication|Telegram|Telegram.TelegramDesktop|telegram.org'
        'Communication|Signal|OpenWhisperSystems.Signal|signal.org'
        'Communication|Slack|SlackTechnologies.Slack|slack.com'
        'Communication|Zoom|Zoom.Zoom|zoom.us'
        'Communication|Microsoft Teams|Microsoft.Teams|teams.microsoft.com'
        'Gaming|Steam|Valve.Steam|store.steampowered.com'
        'Gaming|Epic Games Launcher|EpicGames.EpicGamesLauncher|epicgames.com'
        'Gaming|GOG Galaxy|GOG.Galaxy|gog.com'
        'Gaming|EA app|ElectronicArts.EADesktop|ea.com'
        'Gaming|Ubisoft Connect|Ubisoft.Connect|ubisoft.com'
        'Gaming|Battle.net|Blizzard.BattleNet|battle.net'
        'Media|VLC|VideoLAN.VLC|videolan.org'
        'Media|Spotify|Spotify.Spotify|spotify.com'
        'Media|OBS Studio|OBSProject.OBSStudio|obsproject.com'
        'Media|Audacity|Audacity.Audacity|audacityteam.org'
        'Media|HandBrake|HandBrake.HandBrake|handbrake.fr'
        'Media|MPC-HC|clsid2.mpc-hc|mpc-hc.org'
        'Development|Visual Studio Code|Microsoft.VisualStudioCode|code.visualstudio.com'
        'Development|Git|Git.Git|git-scm.com'
        'Development|GitHub Desktop|GitHub.GitHubDesktop|desktop.github.com'
        'Development|Python 3.13|Python.Python.3.13|python.org'
        'Development|Node.js LTS|OpenJS.NodeJS.LTS|nodejs.org'
        'Development|Notepad++|Notepad++.Notepad++|notepad-plus-plus.org'
        'Development|Windows Terminal|Microsoft.WindowsTerminal|'
        'Development|PowerShell 7|Microsoft.PowerShell|'
        'Development|Docker Desktop|Docker.DockerDesktop|docker.com'
        'Development|Postman|Postman.Postman|postman.com'
        'Utilities|7-Zip|7zip.7zip|7-zip.org'
        'Utilities|WinRAR|RARLab.WinRAR|win-rar.com'
        'Utilities|PowerToys|Microsoft.PowerToys|'
        'Utilities|Everything|voidtools.Everything|voidtools.com'
        'Utilities|ShareX|ShareX.ShareX|getsharex.com'
        'Utilities|Rufus|Rufus.Rufus|rufus.ie'
        'Utilities|qBittorrent|qBittorrent.qBittorrent|qbittorrent.org'
        'Utilities|AnyDesk|AnyDeskSoftwareGmbH.AnyDesk|anydesk.com'
        'Utilities|TeamViewer|TeamViewer.TeamViewer|teamviewer.com'
        'Utilities|SumatraPDF|SumatraPDF.SumatraPDF|sumatrapdfreader.org'
        'Utilities|Adobe Acrobat Reader|Adobe.Acrobat.Reader.64-bit|adobe.com/acrobat'
        'Utilities|Bitwarden|Bitwarden.Bitwarden|bitwarden.com'
        'System|CPU-Z|CPUID.CPU-Z|cpuid.com'
        'System|HWiNFO|REALiX.HWiNFO|hwinfo.com'
        'System|Wireshark|WiresharkFoundation.Wireshark|wireshark.org'
        'System|Malwarebytes|Malwarebytes.Malwarebytes|malwarebytes.com'
        'System|Proton VPN|Proton.ProtonVPN|protonvpn.com'
        'Creative|GIMP|GIMP.GIMP|gimp.org'
        'Creative|Blender|BlenderFoundation.Blender|blender.org'
        'Creative|Inkscape|Inkscape.Inkscape|inkscape.org'
        'Creative|Krita|KDE.Krita|krita.org'
        'Creative|Paint.NET|dotPDN.PaintDotNet|getpaint.net'
        'Creative|Figma|Figma.Figma|figma.com'
    )

    # ------------------------------------------------------------------
    # XAML  (single "Carbon" theme)
    # ------------------------------------------------------------------
    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Azeron Tool Box" Width="1120" Height="740" WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanMinimize" FontFamily="Segoe UI" UseLayoutRounding="True">
  <Window.Resources>
    <SolidColorBrush x:Key="BgBrush" Color="#0C0C0D"/>
    <SolidColorBrush x:Key="SurfaceBrush" Color="#131315"/>
    <SolidColorBrush x:Key="CardBrush" Color="#1A1A1D"/>
    <SolidColorBrush x:Key="CardHoverBrush" Color="#232327"/>
    <SolidColorBrush x:Key="TextBrush" Color="#F2F2F3"/>
    <SolidColorBrush x:Key="SubTextBrush" Color="#8D8D95"/>
    <SolidColorBrush x:Key="AccentBrush" Color="#E8E8EC"/>
    <SolidColorBrush x:Key="AccentTextBrush" Color="#111113"/>
    <SolidColorBrush x:Key="LineBrush" Color="#2A2A2F"/>

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
      <Setter Property="Padding" Value="16,9"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="10" Padding="{TemplateBinding Padding}">
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

    <!-- App card (CheckBox) with icon -->
    <Style x:Key="AppCard" TargetType="CheckBox">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="258"/>
      <Setter Property="Height" Value="64"/>
      <Setter Property="Margin" Value="6"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="CheckBox">
            <Border x:Name="bd" Background="{DynamicResource CardBrush}" BorderBrush="{DynamicResource LineBrush}"
                    BorderThickness="1.5" CornerRadius="12" Padding="12,0">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="Auto"/>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Border Width="38" Height="38" CornerRadius="9" Background="#F2F2F5" VerticalAlignment="Center">
                  <Grid>
                    <TextBlock x:Name="lt" FontSize="17" FontWeight="Bold" Foreground="#333338"
                               HorizontalAlignment="Center" VerticalAlignment="Center" Visibility="Collapsed"/>
                    <Image x:Name="ico" Width="26" Height="26" RenderOptions.BitmapScalingMode="HighQuality"
                           HorizontalAlignment="Center" VerticalAlignment="Center"/>
                  </Grid>
                </Border>
                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="12,0,0,0">
                  <TextBlock Text="{TemplateBinding Content}" Foreground="{DynamicResource TextBrush}"
                             FontWeight="SemiBold" FontSize="13" TextTrimming="CharacterEllipsis"/>
                  <TextBlock Text="{TemplateBinding Tag}" Foreground="{DynamicResource SubTextBrush}"
                             FontSize="11" Margin="0,2,0,0"/>
                </StackPanel>
                <Border x:Name="ck" Grid.Column="2" Width="20" Height="20" CornerRadius="10" BorderThickness="1.5"
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
        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
          <Button x:Name="BtnMin" Style="{StaticResource GhostBtn}" Padding="0" Width="36" Height="30" Margin="0,0,6,0">
            <Path Data="M0,0 L11,0" Stroke="{DynamicResource TextBrush}" StrokeThickness="1.6"
                  HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Button>
          <Button x:Name="BtnClose" Style="{StaticResource GhostBtn}" Padding="0" Width="36" Height="30">
            <Path Data="M0,0 L10,10 M10,0 L0,10" Stroke="{DynamicResource TextBrush}" StrokeThickness="1.6"
                  HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Button>
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
    foreach ($n in 'TitleBar','BtnMin','BtnClose','Nav','CardPanel','Search','SearchHint','BtnAll','BtnNone','BtnInstall','Log','Progress','Status','AdminInfo') {
        $ui[$n] = $win.FindName($n)
    }
    $ctx = @{ Cards = New-Object System.Collections.ArrayList; Cat = 'All'; Busy = $false }

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

    # Icons: loaded asynchronously (UI never waits), cached on disk after first download
    $ctx.IconDir = Join-Path $env:APPDATA 'AzeronToolBox\icons'
    try { if (-not (Test-Path $ctx.IconDir)) { New-Item -ItemType Directory -Path $ctx.IconDir -Force | Out-Null } } catch {}

    $ctx.LoadIcon = {
        param($card)
        $app = $card.DataContext
        $img = $card.Template.FindName('ico', $card)
        $lt  = $card.Template.FindName('lt',  $card)
        if (-not $img -or $img.Source) { return }
        $lt.Text = $app.Name.Substring(0, 1).ToUpper()
        if (-not $app.Domain) { $lt.Visibility = 'Visible'; return }

        $file   = Join-Path $ctx.IconDir (($app.Domain -replace '[^a-zA-Z0-9]', '_') + '.png')
        $cached = Test-Path $file
        $bi = New-Object Windows.Media.Imaging.BitmapImage
        $bi.BeginInit()
        if ($cached) {
            $bi.CacheOption = 'OnLoad'
            $bi.UriSource   = [Uri]$file
        } else {
            $bi.UriSource = [Uri]('https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&size=128&url=https://' + $app.Domain)
        }
        $bi.EndInit()
        if (-not $cached) {
            $bi.Add_DownloadCompleted({
                try {
                    $enc = New-Object Windows.Media.Imaging.PngBitmapEncoder
                    $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bi))
                    $fs = [IO.File]::Create($file)
                    $enc.Save($fs)
                    $fs.Dispose()
                } catch {}
            }.GetNewClosure())
            $bi.Add_DownloadFailed({ $lt.Visibility = 'Visible' }.GetNewClosure())
        }
        $img.Source = $bi
    }

    # App cards
    $cardStyle = $win.FindResource('AppCard')
    foreach ($line in $catalog) {
        $p  = $line.Split('|')
        $cb = New-Object Windows.Controls.CheckBox
        $cb.Style       = $cardStyle
        $cb.Content     = $p[1]
        $cb.Tag         = $p[0]
        $cb.DataContext = [pscustomobject]@{ Cat = $p[0]; Name = $p[1]; Id = $p[2]; Domain = $p[3] }
        $cb.Add_Checked($ctx.OnToggle)
        $cb.Add_Unchecked($ctx.OnToggle)
        $cb.Add_Loaded({ param($s, $e) & $ctx.LoadIcon $s }.GetNewClosure())
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
                    $ok++;   $q.Enqueue("[OK]   $($a.Name)")
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
