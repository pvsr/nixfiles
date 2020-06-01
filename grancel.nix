{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
  ];

  home.file."bin/alacritty".text = "#!/bin/sh\n/usr/bin/alacritty \"$@\"";
  programs.fish.shellAliases = {
    mpv = "/usr/bin/mpv";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
