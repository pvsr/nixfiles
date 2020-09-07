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
    jetbrains.idea-community
    tmux
  ];

  programs.mpv.enable = true;

  wayland.windowManager.sway.config.output."*".scale = "2";

  #services.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
