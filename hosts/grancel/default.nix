{ lib, inputs, ... }:
{
  local.hosts.grancel = { };

  flake.modules.nixos.grancel = {
    imports = [
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.machines
    ];

    programs.steam.enable = true;

    local.machines = {
      autoStart = false;
      only = [ "grancel" ];
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;

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
  };
}
