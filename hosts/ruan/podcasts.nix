{
  ...
}: {
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [5999];

  services.podcasts = {
    annexDir = "/media/data/annex";
    podcastSubdir = "hosted-podcasts";
    dataDir = "/media/nixos/podcasts";
    fetch = {
      enable = true;
      user = "peter";
      group = "users";
      startAt = "0,8,16:0";
    };
    serve = {
      enable = true;
      bind = "100.64.0.3:5999";
      timeout = 120;
    };
  };
  systemd.services.serve-podcasts.after = ["tailscaled.service"];
  systemd.services.serve-podcasts.wants = ["tailscaled.service"];
}
