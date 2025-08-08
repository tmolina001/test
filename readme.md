# PowerShell Script for HP Driver/Firmware Automation with SCCM

This repository contains a PowerShell script to automate the process of downloading HP driver and firmware updates and creating corresponding packages in Microsoft System Center Configuration Manager (SCCM).

## Documentation

For detailed information on setup and usage, please refer to the documentation in the `docs` folder:

-   **[Prerequisites](./docs/Prerequisites.md):** What you need to install and configure before running the script.
-   **[Usage Guide](./docs/Usage-Guide.md):** How to run the script and understand its parameters.

## Features

-   Automated System Detection to find relevant updates.
-   Integration with the HP Client Management Script Library (HPCMSL).
-   Automated SCCM Package and Program creation.
-   Automated content distribution to a specified Distribution Point Group.
-   Verbose logging and a `-WhatIf` switch for safe execution.
