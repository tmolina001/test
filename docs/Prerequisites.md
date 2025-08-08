# Prerequisites

Before running the automation script, you must ensure the following prerequisites are met on the machine from which you will execute the script.

## 1. Configuration Manager PowerShell Module

The SCCM PowerShell module is required to connect to your site and manage packages.

-   **Requirement:** The SCCM Admin Console must be installed. The PowerShell module is included as part of the console installation.
-   **Verification:** You can check if the console is installed by looking for it in the Start Menu. The script will automatically try to locate the module from the default installation path stored in the `$env:SMS_ADMIN_UI_PATH` environment variable.

## 2. HP Client Management Script Library (HPCMSL)

HPCMSL is the HP-provided PowerShell library used to query for and download driver and firmware SoftPaqs.

-   **Requirement:** You must download and install this library from HP's official source.
-   **Download Link:** [HP Client Management Solutions](https://www.hp.com/us-en/solutions/client-management-solutions.html) (Look for the HP Client Management Script Library download).
-   **Installation:** Run the downloaded `.exe` installer.
-   **Verification:** After installation, open a PowerShell console and run `Get-Module -Name HP.CMSL -ListAvailable`. If the module is listed, the installation was successful. Note that the module name `HP.CMSL` is an assumption and may be different.
