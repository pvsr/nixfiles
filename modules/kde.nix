{
  flake.modules.nixos.kde =
    { lib, pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;
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
        xwaylandvideobridge
      ];

    };
}
