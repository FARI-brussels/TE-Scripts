{ config, pkgs, ... }:

{
  # Minimal generic kernel modules
  boot.kernelModules = [
    "ahci"         # SATA
    "xhci_pci"     # USB 3.x
    "i2c_i801"     # optional for some laptops
    "kvm_intel"    # virtualization (optional)
    "kvm_amd"      # if AMD CPU
  ];

  # Enable CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Enable sound and input devices
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.keyboard.enable = true;
  hardware.mouse.enable = true;

  # Firmware for Wi-Fi / Bluetooth
  hardware.firmware.enableAll = true;

  # Use default root filesystem — installer will handle target partition
  fileSystems = {};
  swapDevices = [];

  # Generic video support
  hardware.opengl.enable = true;
}
