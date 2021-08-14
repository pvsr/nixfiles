{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.packages = with pkgs; [
    diceware
    qutebrowser
  ];

  programs.mpv.enable = true;
}
