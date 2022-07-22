{
  pkgs,
  config,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [5999];

  services.podcasts = {
    annexDir = "/media/data/annex";
    podcastSubdir = "hosted-podcasts";
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
