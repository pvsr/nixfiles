{ lib, ... }:
{
  flake.modules.nixos.kde =
    { config, pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = !config.boot.isContainer;
      services.speechd.enable = lib.mkForce false;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        (lib.getBin qttools)
        ark
        elisa
        gwenview
        okular
        kate
        khelpcenter
        baloo-widgets
        krdp
      ];
    };
}
