{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./nixos.nix
  ];

  home.packages = with pkgs; [
    firefox
    river
    foot
    seatd
  ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings.global = {
      username_cmd = "pass show spotify/userid";
      password_cmd = "pass show spotify.com";
      backend = "pulseaudio";
    };
  };

}
