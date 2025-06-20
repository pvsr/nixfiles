{
  flake.modules.homeManager.nixos =
    { pkgs, ... }:
    {
      xsession.windowManager.i3.enable = true;
      home.packages = with pkgs; [
        xwayland-satellite-unstable
      ];
    };
}
