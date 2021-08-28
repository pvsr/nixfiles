{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  # networking.interfaces.wlp5s0.useDHCP = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.hosts = { "192.168.0.110" = [ "ruan" ]; };

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  services = {
    openssh.enable = true;
    openssh.ports = [ 23232 ];
    openssh.passwordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [
    23232
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "21.05";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e1e91f6c-0c5a-407e-b784-f28431839036";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/e1e91f6c-0c5a-407e-b784-f28431839036";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A253-A1F7";
      fsType = "vfat";
    };

  fileSystems."/media/data" =
    {
      device = "/dev/disk/by-uuid/aec1cba5-6ddb-4156-ad7e-a5a5ed6a00f7";
      fsType = "ext4";
    };

  fileSystems."/media/arch" =
    {
      device = "/dev/disk/by-uuid/0b865d88-2a0e-438a-96e8-bb3035d0b488";
      fsType = "ext4";
    };

}
