# Usage Guide

This guide provides detailed instructions on how to use the `Create-HPDriverSCCMPackages.ps1` script.

## Important Pre-execution Steps

1.  **Verify HPCMSL Cmdlets:** The script uses placeholder names for HPCMSL cmdlets (`Find-HPSoftPaqs`, `Save-HPSoftPaq`) and their parameters. This is the most critical step you must perform before execution.
    -   After installing HPCMSL, open PowerShell and run `Get-Command -Module HP.CMSL` to list all available commands.
    -   Identify the correct cmdlets for finding and saving SoftPaqs.
    -   Update the script with the correct cmdlet names and adjust the parameters as needed.

2.  **Check Silent Install Switches:** The script uses a generic silent install command: `$softpaqId.exe /s /v/qn`. This may not work for all SoftPaqs.
    -   HP typically provides the correct silent installation command inside a `.cva` file that is associated with the SoftPaq.
    -   You may need to inspect these files for the drivers you are packaging to ensure they install silently and correctly. Update the `$installCommand` variable in the script accordingly.

## Executing the Script

Open a PowerShell console, navigate to the project directory, and execute the script with the required parameters.

### Parameters

-   `-SCCMServer` (Mandatory): The FQDN of your SCCM primary site server.
-   `-SiteCode` (Mandatory): The three-letter site code of your SCCM site (e.g., "P01").
-   `-PackageSourcePath` (Mandatory): The UNC path to your central package source share. The script will create subfolders for each model and SoftPaq within this path.
-   `-DistributionPointGroupName` (Mandatory): The name of the Distribution Point Group to which the new packages will be distributed.
-   `-Verbose` (Optional): Use this switch to get detailed logging output of the script's operations.
-   `-WhatIf` (Optional): Use this switch to see what actions the script *would* take without actually making any changes to your SCCM environment. This is highly recommended for a first run.

### Example

```powershell
# Dry run to see what the script will do
.\Create-HPDriverSCCMPackages.ps1 -SCCMServer "sccm.yourdomain.com" -SiteCode "P01" -PackageSourcePath "\\server\sources\HP" -DistributionPointGroupName "All DPs" -WhatIf

# Live run with detailed logging
.\Create-HPDriverSCCMPackages.ps1 -SCCMServer "sccm.yourdomain.com" -SiteCode "P01" -PackageSourcePath "\\server\sources\HP" -DistributionPointGroupName "All DPs" -Verbose
```
