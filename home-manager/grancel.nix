{ pkgs, ... }:
{
  imports = [
    ./nixos.nix
    ./tasks.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [ sptlrx ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; };
    settings.global = {
      username_cmd = "${pkgs.pass}/bin/pass show spotify/userid";
      password_cmd = "${pkgs.pass}/bin/pass show spotify.com";
      backend = "pulseaudio";
      bitrate = 160;
      initial_volume = "100";
    };
  };

  services.mpris-proxy.enable = true;
}
