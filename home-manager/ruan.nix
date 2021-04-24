{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
    ./linux.nix
  ];

  home.packages = with pkgs; [
    ranger
    diceware
    beets
    qutebrowser
    mrsh
    termite
    psmisc
    #jetbrains.idea-community
    lsof
    tmux
  ];

  programs.mpv.enable = true;

  wayland.windowManager.sway.config.output."*".scale = "2";

  #home.stateVersion = "21.05";
}
