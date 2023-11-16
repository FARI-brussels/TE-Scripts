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

- `update_ips.sh`: Uses `curl` to fetch devices from the CMS and `arp-scan` to identify devices on the network. It updates the CMS with new IP addresses if they have changed.
- `enable_autologin.sh`: Configures autologin for user `fari` by modifying `lightdm` configuration in `/etc/lightdm/lightdm.conf.d`.
- `create-desktop-icons.sh`: Iterates through an array of titles and prefixes to create `.desktop` entries for creating a desktop icon for direct launching of demos.
- `clone_or_pull_repo.sh`: Clones or pulls a repository into a specified directory, ensuring the latest code is present.
- `launch_welcome_screen.sh`: Kills any existing process on port 8080, clears Chromium's cache, and launches a Python server for the welcome screen, followed by opening Chromium in kiosk mode.
- `update_all_devices.sh`: Iteratively calls `ssh_to_device.sh` to run `command.sh` on each device registered in the CMS. This use this script : create or modify the `command.sh` and append the line that you want to execute on all devices. The run the `update_all_devices.sh` script.
- `ssh_to_device.sh`: Attempts to establish an SSH connection to a device by name, fetching its IP from the CMS and re-running `update_ips.sh` if necessary.

**Note:** The provided documentation captures the overarching structure and functionality of the codebase, excluding the detailed code content. The analysis does not enumerate specific implementations within each file or script due to constraints of the medium, but provides a sufficient high-level understanding.