{
  pkgs,
  config,
  lib,
  ...
}: let
  podcastPath = "/media/data/annex/hosted-podcasts";
in {
  networking.firewall.allowedTCPPorts = [5999];

  services.podcasts = {
    podcastDir = podcastPath;
    dataDir = "/media/nixos/podcasts";
    fetch = {
      enable = true;
      user = "peter";
      group = "users";
      startAt = "5,17:0";
    };
    serve = {
      enable = true;
      bind = "0.0.0.0:5999";
    };
  };
}
