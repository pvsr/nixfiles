{
  local.desktops.grancel = {
    programs.steam.enable = true;

    hardware.facter.reportPath = ./facter.json;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "24.05";
  };
}
