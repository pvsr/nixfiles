{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.packages = with pkgs; [
    transmission
  ];

  services.mpd.enable = true;
  programs.mpv.profiles.standard.gpu-context = "wayland";
}
