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
      bind = "100.64.0.3:5999";
    };
  };
  systemd.services.serve-podcasts.after = ["tailscaled.service"];
}
