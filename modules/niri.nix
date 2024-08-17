{
  lib,
  pkgs,
  modulesPath,
  ...
}:
lib.mkMerge [
  { xdg.portal.configPackages = [ pkgs.niri ]; }
  (import "${modulesPath}/programs/wayland/wayland-session.nix" { inherit lib pkgs; })
]
