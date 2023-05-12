{
  config,
  pkgs,
  ...
}: {
  age.secrets."miniflux-credentials" = {
    file = ./secrets/miniflux-credentials.age;
  };

  services.miniflux = {
    enable = true;
    config.LISTEN_ADDR = "100.64.0.3:8080";
    adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
  };
  systemd.services.miniflux.after = ["tailscaled.service"];
}
