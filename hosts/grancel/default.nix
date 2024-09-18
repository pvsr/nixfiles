{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
    ../../modules/niri.nix
    ../../modules/steam.nix
    inputs.srvos.nixosModules.desktop
  ];

  local.machines = {
    enable = true;
    autoStart = false;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grancel";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.useDHCP = lib.mkDefault true;

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
