param([string]$Compiler = 'gcc')
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$executable = Join-Path ([System.IO.Path]::GetTempPath()) ('pendu-test-' + [guid]::NewGuid() + '.exe')

function Invoke-Game([string]$InputText) {
    $info = [System.Diagnostics.ProcessStartInfo]::new()
    $info.FileName = $executable
    $info.UseShellExecute = $false
    $info.RedirectStandardInput = $true
    $info.RedirectStandardOutput = $true
    $process = [System.Diagnostics.Process]::Start($info)
    try {
        $process.StandardInput.Write($InputText)
        $process.StandardInput.Close()
        $outputTask = $process.StandardOutput.ReadToEndAsync()
        if (-not $process.WaitForExit(5000)) {
            $process.Kill()
            throw 'Le jeu ne termine pas dans le delai imparti.'
        }
        $output = $outputTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) { throw 'Le jeu a echoue.' }
        return $output
    } finally { $process.Dispose() }
}

try {
    & $Compiler -std=c11 -Wall -Wextra -Wpedantic -Werror '-I' $repo (Join-Path $PSScriptRoot 'test_driver.c') (Join-Path $repo 'mycode.c') -o $executable
    if ($LASTEXITCODE -ne 0) { throw 'Compilation des tests impossible.' }
    $secret = [int](& $executable --secret)
    $wrong = ($secret + 1) % 101
    $cases = @(
        @{ Name='Victoire immediate'; InputText="$secret`n"; Expected='gagne et il vous reste : 5 vies' },
        @{ Name='Victoire au dernier essai'; InputText=("$wrong`n" * 4) + "$secret`n"; Expected='gagne et il vous reste : 1 vies' },
        @{ Name='Defaite apres cinq erreurs'; InputText=("$wrong`n" * 5); Expected='perdu et il vous reste : 0 vie' },
        @{ Name='Texte, bornes et nombre trop grand'; InputText="abc`n-1`n101`n99999999999999999999999999999`n$secret`n"; Expected='gagne et il vous reste : 5 vies' },
        @{ Name='Decimale, suffixe et ligne vide'; InputText="1.5`n42abc`n`n$secret`n"; Expected='gagne et il vous reste : 5 vies' },
        @{ Name='Ligne trop longue'; InputText=('a' * 300) + "`n$secret`n"; Expected='gagne et il vous reste : 5 vies' },
        @{ Name='Espaces acceptes'; InputText="  $secret  `n"; Expected='gagne et il vous reste : 5 vies' },
        @{ Name='Fin de saisie'; InputText=''; Expected='Partie interrompue' },
        @{ Name='Derniere ligne sans saut'; InputText="$secret"; Expected='gagne et il vous reste : 5 vies' }
    )
    foreach ($case in $cases) {
        $output = Invoke-Game $case.InputText
        if (-not $output.Contains($case.Expected)) { throw "ECHEC : $($case.Name)`n$output" }
        Write-Output "OK : $($case.Name)"
    }
    Write-Output "$($cases.Count) tests reussis."
} finally {
    if (Test-Path -LiteralPath $executable) { Remove-Item -LiteralPath $executable }
}
