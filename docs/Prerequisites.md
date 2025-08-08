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

## 3. Network Requirements

The script needs to connect to HP's servers to check for and download SoftPaqs.

-   **Internet Access:** The machine running the script must have outbound internet access on port 443 (HTTPS) and potentially port 80 (HTTP) and 21 (FTP), as the download mechanism is determined by the HPCMSL tool.
-   **Firewall Configuration:** If you are in an environment with a restrictive firewall, you will need to ensure that the script is allowed to communicate with HP's update servers. The specific URLs and IP addresses are managed by HP and may change. You may need to monitor network traffic from the script's execution to identify the specific hostnames (e.g., `ftp.hp.com`, `hpia.hpcloud.hp.com`, etc.) that need to be whitelisted in your firewall.

## 4. Permissions

The user or system account running this script requires specific permissions to function correctly.

-   **SCCM Security Role:** The account needs a security role in Configuration Manager with permissions to create, modify, and read Packages, Programs, and Distribution Point Groups. A role like **Application Administrator** might be sufficient, but it's best to create a custom role with the minimum required permissions for this task.
-   **UNC Share Permissions:** The account must have **Read and Write** permissions to the Package Source Path you provide as a parameter. This is where the script will download and store the driver source files.
-   **Local Administrator Rights:** It is highly recommended to run the PowerShell session with elevated (Run as Administrator) privileges, especially if the script needs to interact with system-level components or install modules.
