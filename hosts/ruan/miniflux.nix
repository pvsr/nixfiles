{ config, ... }:
{
  age.secrets."miniflux-credentials" = {
    file = ./secrets/miniflux-credentials.age;
  };

  services.miniflux = {
    enable = config.services.tailscale.enable;
    config.LISTEN_ADDR = "${config.local.tailscale.ip}:8080";
    adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
  };
  systemd.services.miniflux.after = [ "tailscaled.service" ];
  systemd.services.miniflux.wants = [ "tailscaled.service" ];
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8080 ];
}
