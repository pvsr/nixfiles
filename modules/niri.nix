{
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  waylandSession = import "${modulesPath}/programs/wayland/wayland-session.nix" { inherit lib pkgs; };
in
{
  imports = [ waylandSession ];

  xdg.portal.configPackages = [ pkgs.niri ];
}
