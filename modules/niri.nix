{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
}
