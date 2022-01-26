{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./nixos.nix
    ./river/river.nix
  ];

  home.packages = with pkgs; [
    firefox
    spotify-tui
  ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings.global = {
      username_cmd = "${pkgs.pass}/bin/pass show spotify/userid";
      password_cmd = "${pkgs.pass}/bin/pass show spotify.com";
      backend = "pulseaudio";
    };
  };

}
