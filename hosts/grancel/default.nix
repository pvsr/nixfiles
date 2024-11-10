{ config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/steam.nix
    inputs.srvos.nixosModules.desktop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grancel";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.useDHCP = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh.enable = true;
    openssh.ports = [
      22
      23232
    ];
  };

  networking.firewall.allowedTCPPorts = [ 23232 ];

  system.stateVersion = "24.05";
}
