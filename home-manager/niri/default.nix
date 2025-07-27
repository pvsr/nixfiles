{ inputs, ... }:
{
  flake.modules.homeManager.nixos =
    { pkgs, ... }:
    {
      xsession.windowManager.i3.enable = true;
      home.packages = with pkgs; [
        inputs.niri.packages.${pkgs.system}.xwayland-satellite-unstable
      ];
    };
}
