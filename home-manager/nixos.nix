{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.packages = with pkgs; [
    diceware
    beets
    qutebrowser
  ];

  programs.mpv.enable = true;
}
