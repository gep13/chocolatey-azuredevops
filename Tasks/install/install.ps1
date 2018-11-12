[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {
  $chocoInstallLocation = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine")
	if(-not (Test-Path $chocoInstallLocation)) {
		Write-Output "Environment variable 'ChocolateyInstall' was not found in the system variables. Attempting to find it in the user variables..."
		$chocoInstallLocation = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User")
	}

	$chocoExe = "$chocoInstallLocation\choco.exe"

	if (-not (Test-Path $chocoExe)) {
		throw "Chocolatey was not found."
  }

  [string]$packageId = Get-VstsInput -Name 'packageId' -Require
  [string]$packageVersion = Get-VstsInput -Name 'packageVersion'
  [bool]$pre = Get-VstsInput -Name 'pre' -AsBool -Default $false
  [string]$source = Get-VstsInput -Name 'source'
  [bool]$force = Get-VstsInput -Name 'force' -AsBool -Default $false
  [bool]$x86 = Get-VstsInput -Name 'x86' -AsBool -Default $false
  [string]$installArgs = Get-VstsInput -Name 'installargs'
  [bool]$override = Get-VstsInput -Name 'override' -AsBool -Default $false
  [string]$params = Get-VstsInput -Name 'params'
  [string]$extraArguments = Get-VstsInput -Name 'extraArguments'
  [bool]$debug = Get-VstsInput -Name 'debug' -AsBool -Default $false
  [bool]$verbose = Get-VstsInput -Name 'verbose' -AsBool -Default $false
  [bool]$trace = Get-VstsInput -Name 'trace' -AsBool -Default $false

  $chocolateyVersion = & $chocoExe --version
  Write-Output "Running Chocolatey Version: $chocolateyVersion"

  $chocolateyArguments = @()
  if([System.Version]::Parse($chocolateyVersion) -ge [System.Version]::Parse("0.9.8.33")) {
    Write-Output "Adding -y to arguments"
    $chocolateyArguments += @("-y", "")
  }

  if([System.Version]::Parse($chocolateyVersion) -ge [System.Version]::Parse("0.10.4")) {
    Write-Output "Adding --no-progress to arguments"
    $chocolateyArguments += @("--no-progress", "")
  }

  if($packageVersion) {
    Write-Output "Adding --version to arguments"
    $chocolateyArguments += @("--version", $packageVersion)
  }

  if($pre) {
    Write-Output "Adding --pre to arguments"
    $chocolateyArguments += @("--pre", "")
  }

  if($source) {
    Write-Output "Adding --source to arguments"
    $chocolateyArguments += @("--version", $source)
  }

  if($force) {
    Write-Output "Adding --force to arguments"
    $chocolateyArguments += @("--force", "")
  }

  if($x86) {
    Write-Output "Adding --x86 to arguments"
    $chocolateyArguments += @("--x86", "")
  }

  if($installArgs) {
    Write-Output "Adding --install-arguments to arguments"
    $chocolateyArguments += @("--install-arguments", $installArgs)
  }

  if($override) {
    Write-Output "Adding --override-arguments to arguments"
    $chocolateyArguments += @("--override-arguments", "")
  }

  if($params) {
    Write-Output "Adding --package-parameters to arguments"
    $chocolateyArguments += @("--package-parameters", $params)
  }

  if($extraArguments) {
    Write-Output "Adding extra arguments"
    $chocolateyArguments += @($extraArguments, "")
  }

  if($debug) {
    Write-Output "Adding --debug to arguments"
    $chocolateyArguments += @("--debug", "")
  }

  if($verbose) {
    Write-Output "Adding --verbose to arguments"
    $chocolateyArguments += @("--verbose", "")
  }

  if($trace) {
    Write-Output "Adding --trace to arguments"
    $chocolateyArguments += @("--trace", "")
  }

  & $chocoExe install $packageId $($chocolateyArguments)
} catch {
	Write-VstsTaskError $_.Exception.Message
	throw
} finally {
  Trace-VstsLeavingInvocation $MyInvocation
}
