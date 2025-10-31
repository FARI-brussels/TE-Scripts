{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- Basic system setup ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";

  # --- Create a user for demos ---
  users.users.fari = {
    isNormalUser = true;
    description = "Demo User";
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
    password = "fari.brussels"
    packages = with pkgs; [
      nodejs_20          # Node.js
      python312          # Python
      uv                 # Fast Python package manager
      git
      curl
      chromium           # Browser (supports WebSerial)
      vscode             # Visual Studio Code
    ];
  };

  # --- Desktop environment ---
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # --- Allow unfree software (VS Code) ---
  nixpkgs.config.allowUnfree = true;

  # --- System-wide packages ---
  environment.systemPackages = with pkgs; [
    vim
  ];

  # --- Enable important services ---
  services.flatpak.enable = true;
  services.printing.enable = true;
  programs.git.enable = true;

  # --- WebSerial support ---
  # The "dialout" group grants access to /dev/ttyUSB*, /dev/ttyACM*, etc.
  # Already handled above for the demo user.

  # --- Enable automatic login for convenience (optional) ---
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "fari";
}
