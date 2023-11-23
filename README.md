## Codebase Analysis and Documentation

### Introduction
This codebase comprises a suite of bash scripts designed to manage a network of single-board computers (SBCs) for running various Linux-based demonstrations. These scripts provide functionalities like updating IP addresses, enabling autologin, cloning/pulling repository updates, launching welcome screens, and creating desktop icons for easier handling of individual demonstrations.

### Code Organization
The codebase is organized into several key files and a directory dedicated to scripts for individual demonstrations. It follows a standard bash scripting methodology to perform system administration tasks.

Here is a brief overview of each file and directory:

- `update_ips.sh`: Updates the IP addresses of SBCs in the CMS based on arp-scan results.
- `enable_autologin.sh`: Enables autologin on SBCs to bypass the login screen.
- `create-desktop-icons.sh`: Generates desktop icons for each demonstration.
- `clone_or_pull_repo.sh`: Clones or updates repositories with demo-related code.
- `launch_welcome_screen.sh`: Starts a demo-specific welcome screen.
- `update_all_devices.sh`: Updates all devices by running a command on them using SSH.
- `ssh_to_device.sh`: Provides SSH access to a specific SBC by its device name.

The `individual-demos/` directory contains scripts, each corresponding to a particular demo (e.g., `chatbots.sh`, `smartprothesis.sh`).

### Functionality of one of the individual demo Script: `animalwelfare.sh`
The `animalwelfare.sh` script sets up the Animal Welfare demonstration. It syncs the demo and welcome screen code from their respective repositories, launches the welcome screen, and runs the Flask application related to the Animal Welfare demonstration in a new terminal window. It also uses `xdotool` to simulate an escape keypress to exit the gnome menu.

### Dependencies and External Libraries
The codebase leverages a variety of Linux utilities, such as `curl`, `jq`, `awk`, `arp-scan`, `xdotool`, and relies on external software like Flask, Python, Git, and Chromium-browser. The scripts interact with a specific CMS that manages device information and are reliant on network access to function properly.

### Environment and Setup
To replicate the environment the scripts are intended to run in, one must ensure that all dependent programs (`curl`, `jq`, `git`, `python`, `flask`, `xdotool`, `arp-scan`) are installed on the SBCs. This should be the case if you use one of the custom fari image availlable in the [T&E technical documenation](https://te-technical-documentation.readthedocs.io/en/latest/) or if you follow the [instruction](https://te-technical-documentation.readthedocs.io/en/latest/components.html#setting-up-a-fari-image-for-a-new-sbc-type) for setting up a nex distro

The SBCs should be registered in the Content Management System, so that its mac address can be fetched. 

Each script must be made executable using the `chmod +x filename.sh` command before it can be used.

### Conclusion
This codebase documentation provides an overarching view of the scripts used to manage a demo environment running on Linux-based SBCs. By detailing the functionality of one of the demo scripts (`animalwelfare.sh`) and the setup requirements for the entire codebase, developers and administrators should have a sufficient understanding to manage and deploy the demonstrations effectively.

### Individual Script Details

- `update_ips.sh`:
  - **Purpose**: Updates the IP addresses of devices in the CMS based on the results from an `arp-scan`. The script fetches the current IPs from the CMS, compares them with the local network scan results, and updates the CMS if there are discrepancies.
  - **Input Parameters**:
    - No direct input parameters. The script automatically fetches device data from a predefined CMS URL and performs an `arp-scan`.
  - **Output**:
    - Console messages showing the IDs and IPs of the devices, and notifications about IP mismatches and updates.
    - Updates the CMS with the new IP addresses when discrepancies are found.
  - **Example Usage**:
    - To update the IP addresses of devices: ``./update_ips.sh``
  - **Additional Notes**:
    - The script assumes that the CMS API is accessible and that the device data structure in the CMS matches the expected format.
    - It requires `curl`, `jq`, and `arp-scan` to be installed on the system.
    - The script does not implement authentication for CMS access, which may be a security concern.
    - There is no handling for potential errors during the CMS update process.

- `enable_autologin.sh`:
  - **Purpose**: Enables autologin for a specified user (in this case, 'fari') on Single Board Computers (SBCs) by modifying the LightDM configuration file. This eliminates the need to enter a password at startup.
  - **Input Parameters**:
    - No direct input parameters. The script works with a predefined file path (`/etc/lightdm/lightdm.conf.d/11-armbian.conf`).
  - **Output**:
    - Console messages indicating success or failure of the operation.
    - Modifies the LightDM configuration file to enable autologin.
  - **Example Usage**:
    - To enable autologin: ``sudo ./enable_autologin.sh``
  - **Additional Notes**:
    - The script assumes that the LightDM configuration file exists at the specified path.
    - It requires `sudo` privileges to modify the LightDM configuration file.
    - The script creates a temporary file during its operation, which is removed before the script ends.
    - If the LightDM configuration file does not exist, the script notifies the user and exits without making changes.

- `create-desktop-icons.sh`:
    ⚠️ Not maintained/used anymore
  - **Purpose**: Creates desktop icons for various demonstrations. The script iterates through arrays of titles and prefixes, generating `.desktop` entries. Each entry is configured to launch a specific demonstration script.
  - **Input Parameters**:
    - **TITLES**: An array of titles for the desktop icons.
    - **PREFIX**: Corresponding array of prefixes used to name the `.desktop` files and to specify the execution paths of the demonstration scripts.
  - **Output**:
    - Desktop icon files are created on the user's desktop (`/home/fari/Desktop`).
    - Sets the executable permission for each demonstration script and marks the `.desktop` files as trusted.
    - Console output is minimal, primarily from `gio` and `chmod` commands.
  - **Example Usage**:
    - To create desktop icons: ``./create-desktop-icons.sh``
  - **Additional Notes**:
    - The script is tailored for a specific user directory (`/home/fari`) and assumes the existence of certain paths and files (like the demonstration scripts and icon images).
    - The demonstration scripts (`*.sh` files) need to exist in `/home/fari/Documents/TE-Scripts/individual-demos/`.
    - It also assumes the GNOME desktop environment, as it uses `gio` to set metadata properties on the `.desktop` files.


- `clone_or_pull_repo.sh`: 
  - **Purpose**: Clones or pulls a repository into a specified directory, ensuring the latest code is present.
  - **Input Parameters**:
    - **LOCAL_PATH**: The local directory path for cloning or updating the repository.
    - **REPO_URL**: The URL of the Git repository to clone or pull.
  - **Output**: Console messages indicating status of operations (cloning or updating).
  - **Example Usage**:
    - To clone a new repository: ``./clone_or_pull_repo.sh /path/to/new/repo https://github.com/user/newrepo.git``
    - To update an existing repository: ``./clone_or_pull_repo.sh /path/to/existing/repo``

- `launch_welcome_screen.sh`:
  - **Purpose**: Launches a demo-specific welcome screen by terminating any process on port 8080, clearing the Chromium browser's cache, initiating a Python server, and opening Chromium in kiosk mode with the demo.
  - **Input Parameters**:
    - **WELCOME_SCREEN_PATH**: The directory path where the welcome screen files, including `server.py`, are located.
    - **DEMO_ID**: Identifier for the specific demo to be displayed on the welcome screen.
  - **Output**:
    - Console messages related to process termination, cache clearing, and server/browser launching.
    - Chromium browser opens in kiosk mode displaying the welcome screen for the specified demo.
  - **Example Usage**:
    - To launch a welcome screen: ``./launch_welcome_screen.sh /path/to/welcome_screen demo123``

- `update_all_devices.sh`:
  - **Purpose**: Iteratively updates all devices registered in the CMS by executing a specified command on each device. This is achieved by calling `ssh_to_device.sh` for each device to run `command.sh`.
  - **Input Parameters**:
    - This script does not take direct input parameters. Instead, it relies on `command.sh` containing the command to execute on all devices.
  - **Output**:
    - Console messages indicating the status of updates on each device.
  - **Example Usage**:
    - To update all devices: First, create or modify `command.sh` with the desired command, then run ``./update_all_devices.sh``.
  - **Additional Notes**:
    - The user must ensure that `command.sh` is correctly set up with the necessary command(s) before executing this script (ensure also that the script is executable).
    - This script depends on `ssh_to_device.sh` for SSH access to each device, which in turn requires that each device is accessible and properly configured for SSH.

- `ssh_to_device.sh`:
  - **Purpose**: Establishes an SSH connection to a specific device by its name. It fetches the device's IP address from the CMS, updates the IP addresses if necessary, and then initiates an SSH connection.
  - **Input Parameters**:
    - **device_name**: The name of the device to which an SSH connection is to be established.
  - **Output**:
    - Console messages indicating the process of fetching IP, checking accessibility, updating IPs (if needed), and attempting SSH connection.
    - Initiates an SSH session to the specified device if successful.
  - **Example Usage**:
    - To SSH into a device: ``./ssh_to_device.sh device123``
  - **Additional Notes**:
    - The script relies on the availability and correctness of the IP addresses in the CMS.
    - If the device is not reachable initially, it runs `update_ips.sh` to refresh the IPs from the CMS.
    - The user must have SSH access set up for the target device, and the script assumes SSH access as the user `fari`.
    - Error handling includes a check for IP accessibility and an exit if the IP cannot be found.


**Note:** The provided documentation captures the overarching structure and functionality of the codebase, excluding the detailed code content. The analysis does not enumerate specific implementations within each file or script due to constraints of the medium, but provides a sufficient high-level understanding.