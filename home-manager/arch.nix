{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sway.nix
    ./kakoune.nix
  ];

  targets.genericLinux.enable = true;
  xdg.systemDirs.data = [ "/usr/share" ];

  home.username = "peter";
  home.homeDirectory = "/home/peter";

  home.packages = with pkgs; [
    transmission
  ];

  #home.stateVersion = "21.05";
}
