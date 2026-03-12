# ============================================================
#  Full Stack Freelancer — Auto Setup Script (Windows)
#  Works on Windows 10/11 with PowerShell 5.1+
#  Skips anything already installed — safe to re-run anytime
#  Uses winget (built-in on Win 10 1709+) and optional Chocolatey
# ============================================================

#Requires -Version 5.1

$ErrorActionPreference = "Continue"

# ─── Colors ──────────────────────────────────────────────────
function Write-Ok    { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Skip  { param($msg) Write-Host "  ⏭  $msg — already installed" -ForegroundColor Yellow }
function Write-Info  { param($msg) Write-Host "  ℹ  $msg" -ForegroundColor Cyan }
function Write-Warn  { param($msg) Write-Host "  ⚠  $msg" -ForegroundColor Yellow }
function Write-Err   { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-H1    { param($msg) Write-Host "`n━━━ $msg ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue }

# ─── Admin Check ─────────────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# ─── Tool Selection ──────────────────────────────────────────
$allTools = [ordered]@{
    "git"         = @{ Name = "Git"; WingetId = "Git.Git"; Cmd = "git" }
    "gh"          = @{ Name = "GitHub CLI"; WingetId = "GitHub.cli"; Cmd = "gh" }
    "node"        = @{ Name = "Node.js 20 LTS"; WingetId = "OpenJS.NodeJS.LTS"; Cmd = "node" }
    "vscode"      = @{ Name = "VS Code"; WingetId = "Microsoft.VisualStudioCode"; Cmd = "code" }
    "docker"      = @{ Name = "Docker Desktop"; WingetId = "Docker.DockerDesktop"; Cmd = "docker" }
    "flutter"     = @{ Name = "Flutter SDK"; WingetId = "Google.Flutter"; Cmd = "flutter" }
    "python"      = @{ Name = "Python 3"; WingetId = "Python.Python.3.12"; Cmd = "python" }
    "aws"         = @{ Name = "AWS CLI"; WingetId = "Amazon.AWSCLI"; Cmd = "aws" }
    "postgresql"  = @{ Name = "PostgreSQL 16"; WingetId = "PostgreSQL.PostgreSQL.16"; Cmd = "psql" }
    "redis"       = @{ Name = "Redis (Memurai)"; WingetId = "Memurai.MemuraiDeveloper"; Cmd = "memurai-cli" }
    "nginx"       = @{ Name = "Nginx"; WingetId = $null; ChocoId = "nginx"; Cmd = "nginx" }
    "claude"      = @{ Name = "Claude Code CLI"; WingetId = $null; NpmPkg = "@anthropic-ai/claude-code"; Cmd = "claude" }
    "typescript"  = @{ Name = "TypeScript"; WingetId = $null; NpmPkg = "typescript"; Cmd = "tsc" }
    "nestjs"      = @{ Name = "NestJS CLI"; WingetId = $null; NpmPkg = "@nestjs/cli"; Cmd = "nest" }
    "eas"         = @{ Name = "EAS CLI (Expo)"; WingetId = $null; NpmPkg = "eas-cli"; Cmd = "eas" }
}

# ─── Banner ──────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Full Stack Freelancer — Windows Setup      ║" -ForegroundColor Cyan
Write-Host "║   React Native • Flutter • Node • Next.js    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "  OS: Windows $([System.Environment]::OSVersion.Version.Major)"
Write-Host "  Re-run anytime — skips what's already installed"
Write-Host ""

# ─── Mode Selection ──────────────────────────────────────────
param(
    [switch]$All,
    [switch]$SkillsOnly,
    [string[]]$Only,
    [switch]$List
)

# Parse args from command line if not using param
if ($args -contains "--all")         { $All = $true }
if ($args -contains "--skills-only") { $SkillsOnly = $true }
if ($args -contains "--list")        { $List = $true }

# Handle --only tool1,tool2
for ($i = 0; $i -lt $args.Count; $i++) {
    if ($args[$i] -eq "--only" -and ($i + 1) -lt $args.Count) {
        $Only = $args[$i + 1] -split ","
    }
}

if ($List) {
    Write-Host "`nAvailable tools:" -ForegroundColor Cyan
    Write-Host "────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($key in $allTools.Keys) {
        $tool = $allTools[$key]
        $installed = if (Get-Command $tool.Cmd -ErrorAction SilentlyContinue) { "✅" } else { "  " }
        Write-Host "  $installed $($key.PadRight(15)) $($tool.Name)"
    }
    Write-Host "`nUsage:" -ForegroundColor Yellow
    Write-Host "  .\setup-windows.ps1                    # Interactive — choose what to install"
    Write-Host "  .\setup-windows.ps1 --all              # Install everything"
    Write-Host "  .\setup-windows.ps1 --skills-only      # Install only Claude skills"
    Write-Host "  .\setup-windows.ps1 --only node,git    # Install specific tools only"
    Write-Host "  .\setup-windows.ps1 --list             # Show this list"
    Write-Host ""
    exit 0
}

# ─── Interactive Selection ───────────────────────────────────
$selectedTools = @{}

if ($SkillsOnly) {
    Write-Info "Skills-only mode — skipping tool installation"
}
elseif ($Only.Count -gt 0) {
    foreach ($key in $Only) {
        $key = $key.Trim().ToLower()
        if ($allTools.Contains($key)) {
            $selectedTools[$key] = $allTools[$key]
        } else {
            Write-Warn "Unknown tool: $key (skipping)"
        }
    }
    Write-Info "Installing selected tools: $($selectedTools.Keys -join ', ')"
}
elseif ($All) {
    $selectedTools = $allTools
    Write-Info "Installing all tools"
}
else {
    # Interactive mode
    Write-Host "Select tools to install (Enter = skip, Y = install):" -ForegroundColor Cyan
    Write-Host "────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""

    foreach ($key in $allTools.Keys) {
        $tool = $allTools[$key]
        $exists = [bool](Get-Command $tool.Cmd -ErrorAction SilentlyContinue)

        if ($exists) {
            Write-Skip "$($tool.Name)"
            continue
        }

        $response = Read-Host "  Install $($tool.Name)? (y/N)"
        if ($response -match "^[Yy]") {
            $selectedTools[$key] = $tool
        }
    }

    if ($selectedTools.Count -eq 0) {
        Write-Info "No tools selected — skipping to skills installation"
    }
}

# ─── Helpers ─────────────────────────────────────────────────

function Test-CommandExists {
    param($cmd)
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Install-WithWinget {
    param($wingetId, $name)

    if (-not (Test-CommandExists "winget")) {
        Write-Err "winget not found — install App Installer from Microsoft Store"
        return $false
    }

    Write-Info "Installing $name via winget..."
    try {
        winget install --id $wingetId --accept-package-agreements --accept-source-agreements --silent
        Write-Ok "$name installed"
        return $true
    } catch {
        Write-Warn "$name install failed — try manually: winget install $wingetId"
        return $false
    }
}

function Install-WithNpm {
    param($pkg, $name)

    if (-not (Test-CommandExists "npm")) {
        Write-Warn "npm not found — install Node.js first, then re-run"
        return $false
    }

    Write-Info "Installing $name via npm..."
    try {
        npm install -g $pkg 2>$null
        Write-Ok "$name installed"
        return $true
    } catch {
        Write-Warn "$name install failed — try: npm install -g $pkg"
        return $false
    }
}

function Install-WithChoco {
    param($chocoId, $name)

    if (-not (Test-CommandExists "choco")) {
        Write-Warn "$name requires Chocolatey. Install from https://chocolatey.org/install"
        return $false
    }

    Write-Info "Installing $name via Chocolatey..."
    try {
        choco install $chocoId -y 2>$null
        Write-Ok "$name installed"
        return $true
    } catch {
        Write-Warn "$name install failed — try: choco install $chocoId"
        return $false
    }
}

# ─── Install Selected Tools ─────────────────────────────────

if (-not $SkillsOnly -and $selectedTools.Count -gt 0) {

    # Check winget availability
    if (-not (Test-CommandExists "winget")) {
        Write-Err "winget is required but not found."
        Write-Info "Install 'App Installer' from Microsoft Store, then re-run."
        Write-Info "Or install tools manually and re-run with --skills-only"
    }

    Write-H1 "Installing Tools"

    foreach ($key in $selectedTools.Keys) {
        $tool = $selectedTools[$key]

        # Skip if already installed
        if (Test-CommandExists $tool.Cmd) {
            Write-Skip $tool.Name
            continue
        }

        # Try winget first, then npm, then choco
        if ($tool.WingetId) {
            Install-WithWinget -wingetId $tool.WingetId -name $tool.Name | Out-Null
        }
        elseif ($tool.NpmPkg) {
            Install-WithNpm -pkg $tool.NpmPkg -name $tool.Name | Out-Null
        }
        elseif ($tool.ChocoId) {
            Install-WithChoco -chocoId $tool.ChocoId -name $tool.Name | Out-Null
        }
        else {
            Write-Warn "$($tool.Name) — no automatic installer available"
        }
    }

    # Refresh PATH so newly installed tools are found
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# ═══════════════════════════════════════════════════════════════
Write-H1 "VS Code Extensions"
# ═══════════════════════════════════════════════════════════════

if (Test-CommandExists "code") {
    $extensions = @(
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "eamodio.gitlens"
        "usernamehw.errorlens"
        "pkief.material-icon-theme"
        "zhuangtongfa.material-theme"
        "dsznajder.es7-react-js-snippets"
        "msjsdiag.vscode-react-native"
        "expo.vscode-expo-tools"
        "Dart-Code.flutter"
        "Dart-Code.dart-code"
        "christian-kohler.path-intellisense"
        "mikestead.dotenv"
        "rangav.vscode-thunder-client"
        "prisma.prisma"
        "ms-azuretools.vscode-docker"
        "bradlc.vscode-tailwindcss"
        "donjayamanne.githistory"
        "Orta.vscode-jest"
        "gruntfuggly.todo-tree"
        "aaron-bond.better-comments"
    )

    $installed = code --list-extensions 2>$null
    foreach ($ext in $extensions) {
        if ($installed -match "(?i)^$([regex]::Escape($ext))$") {
            Write-Skip "VS Code: $ext"
        } else {
            Write-Info "Installing: $ext"
            code --install-extension $ext --force 2>$null | Out-Null
            Write-Ok $ext
        }
    }
} else {
    Write-Warn "VS Code not found — extensions will install on next run"
}

# ═══════════════════════════════════════════════════════════════
Write-H1 "VS Code Settings"
# ═══════════════════════════════════════════════════════════════

$vscodeUserDir = "$env:APPDATA\Code\User"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (Test-Path $vscodeUserDir) {
    $settingsSrc = Join-Path $scriptDir "vscode\settings.json"
    $keybindingsSrc = Join-Path $scriptDir "vscode\keybindings.json"

    if (Test-Path $settingsSrc) {
        $settingsDst = Join-Path $vscodeUserDir "settings.json"
        if (Test-Path $settingsDst) {
            Write-Skip "VS Code settings.json (exists — not overwriting)"
            Write-Info "To replace: Copy-Item '$settingsSrc' '$settingsDst'"
        } else {
            Copy-Item $settingsSrc $settingsDst
            Write-Ok "VS Code settings.json applied"
        }
    }

    if (Test-Path $keybindingsSrc) {
        $keybindingsDst = Join-Path $vscodeUserDir "keybindings.json"
        if (Test-Path $keybindingsDst) {
            Write-Skip "VS Code keybindings.json (exists — not overwriting)"
        } else {
            Copy-Item $keybindingsSrc $keybindingsDst
            Write-Ok "VS Code keybindings.json applied"
        }
    }
} else {
    Write-Info "VS Code settings directory not found — will apply next run"
}

# ═══════════════════════════════════════════════════════════════
Write-H1 "Claude Skills & Config"
# ═══════════════════════════════════════════════════════════════

$claudeDir = "$env:USERPROFILE\.claude"
$skillsDir = "$claudeDir\skills"
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null

$repoSkillsDir = Join-Path $scriptDir "skills"

if (Test-Path $repoSkillsDir) {
    $skillFolders = Get-ChildItem -Directory $repoSkillsDir
    foreach ($skill in $skillFolders) {
        $targetDir = Join-Path $skillsDir $skill.Name
        $targetFile = Join-Path $targetDir "SKILL.md"

        if (Test-Path $targetFile) {
            Write-Skip "Skill: $($skill.Name)"
        } else {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
            Copy-Item -Path (Join-Path $skill.FullName "*") -Destination $targetDir -Recurse -Force
            Write-Ok "Skill installed: $($skill.Name)"
        }
    }
} else {
    Write-Warn "Skills folder not found at $repoSkillsDir"
}

# CLAUDE.md
$claudeMd = Join-Path $claudeDir "CLAUDE.md"
$claudeMdSrc = Join-Path $scriptDir "CLAUDE.md"

if (Test-Path $claudeMd) {
    Write-Skip "~\.claude\CLAUDE.md (already exists)"
} elseif (Test-Path $claudeMdSrc) {
    Copy-Item $claudeMdSrc $claudeMd
    Write-Ok "~\.claude\CLAUDE.md created"
}

# ═══════════════════════════════════════════════════════════════
Write-H1 "Flutter Doctor"
# ═══════════════════════════════════════════════════════════════

if (Test-CommandExists "flutter") {
    Write-Info "Running flutter doctor..."
    flutter doctor 2>$null
} else {
    Write-Warn "Flutter not installed — skipping flutter doctor"
}

# ════════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅  Setup Complete!                        ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "Next steps:" -ForegroundColor White

if (-not (Test-CommandExists "claude")) {
    Write-Host "  1. Open a new PowerShell window, then run: claude auth login" -ForegroundColor Yellow
} else {
    Write-Host "  1. Claude is installed → run: claude" -ForegroundColor Green
}

if (-not (Test-CommandExists "flutter")) {
    Write-Host "  2. Restart terminal and run: flutter doctor" -ForegroundColor Yellow
}

if (-not (Test-CommandExists "docker") -or -not (docker info 2>$null)) {
    Write-Host "  3. Open Docker Desktop to complete setup" -ForegroundColor Yellow
}

if (Test-CommandExists "aws") {
    Write-Host "  4. Configure AWS: aws configure" -ForegroundColor Cyan
}

if (Test-CommandExists "gh") {
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  5. Login to GitHub CLI: gh auth login" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "  Re-run this script anytime — it will skip already-installed items." -ForegroundColor White
Write-Host ""
Write-Host "Usage:" -ForegroundColor DarkGray
Write-Host "  .\setup-windows.ps1                    # Interactive mode" -ForegroundColor DarkGray
Write-Host "  .\setup-windows.ps1 --all              # Install everything" -ForegroundColor DarkGray
Write-Host "  .\setup-windows.ps1 --skills-only      # Only Claude skills" -ForegroundColor DarkGray
Write-Host "  .\setup-windows.ps1 --only node,git    # Specific tools only" -ForegroundColor DarkGray
Write-Host "  .\setup-windows.ps1 --list             # Show available tools" -ForegroundColor DarkGray
Write-Host ""
