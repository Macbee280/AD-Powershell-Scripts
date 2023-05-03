# Active Directory PowerShell Scripts

This repository contains a collection of PowerShell scripts for managing Active Directory.

## Requirements

To use these scripts, you must have the following:

- A Windows computer with PowerShell 5.1 or later installed.
- An account with administrative privileges in the Active Directory domain.

## Installation

1. Clone or download this repository to your computer.
2. Open PowerShell as an administrator.
3. Navigate to the folder containing the downloaded scripts.
4. Run the scripts using the following command:

   ```
   .\script_name.ps1
   ```

## Usage

Each script in this repository has a specific function for managing Active Directory. To use a script, open it in a text editor and follow the instructions in the comments. 

It is recommended to read through the script before running it to ensure that it is doing what you expect. For Active Directory Edits and Exports, make sure to check the correct OU, security groups and settings.

## Scripts

This repository currently contains the following scripts:

- **Import-Module ActiveDirectory.ps1**: Adds users to Active Directory from a CSV file.
- **Export-ADUser.ps1**: Exports user information from Active Directory to a CSV file.
- **Edit Users.ps1**: Edits User information from a CSV file.
- **Add Pager and Office.ps1**: Adds the pager code and office from a CSV file.

## Contributing

Contributions to this repository are welcome! If you have a script that you would like to add, please create a pull request with the new script and an updated README.md file.

## License

This repository is licensed under the MIT License. See LICENSE for more information.
