{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  vscode-server,
  ...
}:

let
  user = "dtzitzon";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEcNl59yh3ZeO6DmCF9dcFHY1Z6cBQUWqfsJR8WZPIG dtzitzon@anduril.com"
  ];
in
{
  imports = [
    ../../modules/shared
    ../../modules/shared/cachix
    ../../modules/shared/anduril
    vscode-server.nixosModules.default
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1ac689da-6d65-4c20-8bb7-721921e02382";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/68DA-485D";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Set your time zone.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    networkmanager.enable = true;
    hostName = "dtzizon-nixos"; # Define your hostname.
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
    # networking.interfaces.enp0s1.useDHCP = lib.mkDefault true;
  };

  # Turn on flag for proprietary software
  nix = {
    settings.allowed-users = [ "${user}" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    # My shell
    zsh.enable = true;
  };

  services = {
    # Let's be able to SSH into this machine
    openssh.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    vscode-server.enable = true;
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    linuxPackages.v4l2loopback
  ];

  system.stateVersion = "24.05";
}
