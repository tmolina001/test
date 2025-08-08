# PowerShell Script for HP Driver/Firmware Automation with SCCM

This repository contains a PowerShell script designed to automate the process of downloading HP driver and firmware updates and creating corresponding packages in Microsoft System Center Configuration Manager (SCCM).

## Features

- **Automated System Detection:** The script automatically detects the local computer's model and operating system to find relevant updates. This can be adapted to run for a list of models.
- **HP CMSL Integration (Placeholder):** It includes logic to interface with the HP Client Management Script Library (HPCMSL) for finding and downloading SoftPaqs.
- **SCCM Package Creation:** For each downloaded update, the script creates a new package in SCCM with detailed information such as name, description, manufacturer, and version.
- **Program Creation:** A corresponding program with a silent installation command is created for each package.
- **Content Distribution:** The script automatically starts the content distribution to a specified Distribution Point Group.
- **Robustness:** Includes error handling, verbose logging, and checks for existing packages to prevent duplication.

## Prerequisites

1.  **Configuration Manager PowerShell Module:** The machine running the script must have the SCCM console installed. The script assumes the console is installed in the default location.
2.  **HP Client Management Script Library (HPCMSL):** The HPCMSL module must be downloaded from the [HP Client Management Solutions](https://www.hp.com/us-en/solutions/client-management-solutions.html) website and installed. The script assumes the module is named `HP.CMSL`.

## How to Use

1.  **Install Prerequisites:** Ensure both the SCCM console and HP CMSL are installed on the machine where you will run the script.
2.  **Verify HPCMSL Cmdlets:** The script uses placeholder names for HPCMSL cmdlets (`Find-HPSoftPaqs`, `Save-HPSoftPaq`). You **must** verify the correct cmdlet names and their parameters. You can list all commands in the module by running `Get-Command -Module HP.CMSL` after installation.
3.  **Execute the script:** Open a PowerShell console and run the script with the required parameters.

### Example

```powershell
.\Create-HPDriverSCCMPackages.ps1 -SCCMServer "sccm.yourdomain.com" -SiteCode "P01" -PackageSourcePath "\\server\sources\SCCM\Packages\HP" -DistributionPointGroupName "All DPs" -Verbose
```

## Parameters

-   `-SCCMServer` (Mandatory): The FQDN of your SCCM primary site server.
-   `-SiteCode` (Mandatory): The three-letter site code of your SCCM site (e.g., "P01").
-   `-PackageSourcePath` (Mandatory): The UNC path to your package source share. The script will create subfolders for each model and SoftPaq within this path.
-   `-DistributionPointGroupName` (Mandatory): The name of the Distribution Point Group to which the new packages will be distributed.
-   `-Verbose` (Optional): Enables detailed logging output.
-   `-WhatIf` (Optional): Shows what would happen if the script were run, without actually making any changes.

## Important Notes

-   **HPCMSL Cmdlets:** The script's ability to find and download drivers is entirely dependent on the correct implementation of the HPCMSL cmdlets. The current names (`Find-HPSoftPaqs`, `Save-HPSoftPaq`) and parameters are logical placeholders and will likely need to be adjusted.
-   **Silent Installation:** The script uses a generic silent install command (`/s /v/qn`). The correct silent install switches for a given HP SoftPaq are typically found in its accompanying `.cva` file. You may need to adjust the `$installCommand` variable in the script or develop more advanced logic to parse CVA files.
