{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
in
{
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
    inputs.srvos.nixosModules.desktop
  ];

  local.gnome.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.rosetta.enable = onMacos;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.spice-vdagentd.enable = true;
  networking.firewall.enable = false;

  services.openssh.listenAddresses = lib.optionals onMacos [ { addr = "192.168.68.2"; } ];

  system.stateVersion = "24.11";
}
