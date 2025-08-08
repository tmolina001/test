<#
.SYNOPSIS
    This script automates the creation of HP driver and firmware packages in SCCM.

.DESCRIPTION
    The script performs the following actions:
    1. Detects the computer's model and operating system.
    2. Uses the HP Client Management Script Library (HPCMSL) to find and download the latest drivers and firmware.
    3. Creates a corresponding package in SCCM for each downloaded update.

.PARAMETER SCCMServer
    The FQDN of the SCCM primary site server.

.PARAMETER SiteCode
    The site code of the SCCM site (e.g., "PS1").

.PARAMETER PackageSourcePath
    The UNC path to the central package source location. The script will create subdirectories here for each model and driver.

.EXAMPLE
    .\Create-HPDriverSCCMPackages.ps1 -SCCMServer "sccm.contoso.com" -SiteCode "P01" -PackageSourcePath "\\server\sources\packages"

.NOTES
    - This script requires the Configuration Manager PowerShell module to be installed on the machine where it's run.
    - It also requires the HP Client Management Script Library (HPCMSL) to be installed.
    - The HPCMSL cmdlet names used in this script (`Find-HPSoftPaqs`, `Save-HPSoftPaq`) are placeholders. You may need to update them to match the actual cmdlets in the library.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory = $true)]
    [string]$SCCMServer,

    [Parameter(Mandatory = $true)]
    [string]$SiteCode,

    [Parameter(Mandatory = $true)]
    [string]$PackageSourcePath,

    [Parameter(Mandatory = $true)]
    [string]$DistributionPointGroupName
)

# --- Main Script Body ---

Write-Output "Starting HP driver package creation process..."

# --- SCCM Connection ---
try {
    Write-Output "Connecting to SCCM site $SiteCode on server $SCCMServer..."
    $sccmModulePath = Join-Path -Path (Split-Path -Path $env:SMS_ADMIN_UI_PATH) -ChildPath "ConfigurationManager.psd1"
    if (-not (Test-Path $sccmModulePath)) {
        throw "Configuration Manager module not found at $sccmModulePath"
    }
    Import-Module $sccmModulePath -Force

    if ($PSCmdlet.ShouldProcess($SiteCode, "Set-Location")) {
        $currentLocation = Get-Location
        Set-Location "$($SiteCode):\"
        Write-Verbose "Successfully changed location to SCCM PSDrive."
    }
}
catch {
    Write-Error "Failed to connect to SCCM site. Error: $_"
    return
}

# --- Distribution Point Group Validation ---
try {
    Write-Verbose "Validating distribution point group: $DistributionPointGroupName"
    $dpGroup = Get-CMDistributionPointGroup -Name $DistributionPointGroupName -ErrorAction Stop
    Write-Verbose "Distribution point group '$($dpGroup.Name)' found."
}
catch {
    Write-Error "Failed to find distribution point group '$DistributionPointGroupName'. Please ensure the name is correct. Error: $_"
    return
}


# Get local system information
try {
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
    $model = $computerSystem.Model
    $manufacturer = $computerSystem.Manufacturer
    $osVersion = $operatingSystem.Caption
    $osArchitecture = $operatingSystem.OSArchitecture

    Write-Output "-> Detected System: $manufacturer $model ($osArchitecture)"
    Write-Output "-> Detected OS: $osVersion"

    if ($manufacturer -notlike "*HP*") {
        Write-Warning "This computer does not appear to be an HP model. The script may not find any drivers."
    }
}
catch {
    Write-Error "Failed to get system information. Error: $_"
    return
}

# --- HP CMSL Section ---
# --- HP CMSL Section ---
# This section uses placeholder cmdlets for finding and downloading HP updates.
# You will need to have the HPCMSL module installed and may need to adjust the
# cmdlet names and parameters based on the official documentation.
try {
    Write-Output "Checking for HP Client Management Script Library (HPCMSL)..."
    # Assuming module name is 'HP.CMSL'. This might need to be verified.
    if (-not (Get-Module -Name "HP.CMSL" -ListAvailable)) {
         throw "HP CMSL module (HP.CMSL) not found. Please download it from hp.com/go/clientmanagement and install it."
    }
    Import-Module "HP.CMSL" -Force
    Write-Verbose "HP.CMSL module imported successfully."

    Write-Output "Searching for available driver and firmware updates for model: $model"

    # Placeholder: Find available SoftPaqs for the current model.
    # The actual cmdlet name and parameters will depend on the HPCMSL module.
    # Common parameters might include -Platform, -Model, -OperatingSystem, -Architecture, -Category.
    # Example: $softpaqs = Find-HPSoftPaqs -Platform $model -OperatingSystem "Windows 10" -Category 'all'
    $softpaqs = Find-HPSoftPaqs -Platform $model -Category 'all'

    if (-not $softpaqs) {
        Write-Output "No new SoftPaqs found for this model."
        return
    }

    Write-Output "Found $($softpaqs.Count) new SoftPaqs."

    foreach ($sp in $softpaqs) {
        $softpaqName = $sp.Name
        $version = $sp.Version
        $category = $sp.Category
        $softpaqId = $sp.Id

        Write-Output "Processing SoftPaq: $softpaqName (Version: $version)"

        # Create a structured path for the download
        $destinationFolder = Join-Path -Path $PackageSourcePath -ChildPath "$model\$softpaqName"
        if (-not (Test-Path -Path $destinationFolder)) {
            New-Item -Path $destinationFolder -ItemType Directory -Force | Out-Null
        }

        # Placeholder: Download the SoftPaq
        Write-Output "  -> Downloading to $destinationFolder"
        # The actual cmdlet might be different. This is a logical guess.
        Save-HPSoftPaq -SoftPaq $sp -Path $destinationFolder -Force

        # --- SCCM Package Creation ---
        $packageName = "HP $model - $softpaqName"
        $packageDescription = "HP Driver/Firmware: $softpaqName for model $model. Version: $version. Category: $category."

        # Check if the package already exists
        Write-Verbose "Checking for existing package named '$packageName'"
        $existingPackage = Get-CMPackage -Name $packageName -ErrorAction SilentlyContinue

        if ($existingPackage) {
            Write-Warning "Package '$packageName' already exists. Skipping creation."
            # Optionally, you could update the existing package here.
            # For now, we just skip it.
            continue
        }

        Write-Output "  -> Creating SCCM Package: $packageName"

        if ($pscmdlet.ShouldProcess($packageName, "Create Package")) {
            $newPackageParams = @{
                Name = $packageName
                Description = $packageDescription
                Path = $destinationFolder
                Manufacturer = $manufacturer
                Language = "English"
                Version = $version
                ErrorAction = "Stop"
            }
            $package = New-CMPackage @newPackageParams

            # Create a program for the package
            # The silent install command is a best guess. HP SoftPaqs can have different switches.
            # Check the .CVA file for the specific SoftPaq for silent install commands.
            $programName = "Install"
            $installCommand = "$($softpaqId).exe /s /v/qn" # Common silent install command
            Write-Verbose "Using install command: $installCommand"

            Write-Output "  -> Creating Program: $programName"
            New-CMProgram -PackageName $packageName -ProgramName $programName -CommandLine $installCommand -RunType Hidden -ProgramRunType Admin -UserInteraction $false -ErrorAction Stop

            # Distribute the package content
            Write-Output "  -> Distributing content to DPG: $DistributionPointGroupName"
            Start-CMContentDistribution -PackageId $package.PackageID -DistributionPointGroupName $DistributionPointGroupName -ErrorAction Stop
            Write-Verbose "Content distribution for package $($package.PackageID) initiated."
        }

    } # End foreach SoftPaq
}
catch {
    Write-Error "An error occurred during the HP update download process. Error: $_"
    return
}
finally {
    # Restore the original location
    if ($currentLocation) {
        Set-Location $currentLocation.Path
    }
}


Write-Output "Script finished."
