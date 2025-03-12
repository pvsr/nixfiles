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
    ./hardware-configuration.nix
    ../../modules/gnome.nix
    ../../modules/impermanence.nix
    inputs.srvos.nixosModules.desktop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.rosetta.enable = onMacos;

  networking.hostName = "jurai";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.spice-vdagentd.enable = true;
  networking.firewall.enable = false;

  services.openssh = lib.mkIf onMacos {
    enable = true;
    startWhenNeeded = true;
    listenAddresses = [ { addr = "192.168.68.2"; } ];
  };

  system.stateVersion = "24.11";

  local.impermanence = {
    enable = true;
    systemdInitrd = true;
    device = "/dev/disk/by-partlabel/disk-root-root";
    persist = "/media/nixos/persist";
  };
}
