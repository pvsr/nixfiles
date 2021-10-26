{ config, pkgs, ... }:
{
  age.secrets."miniflux-credentials" = {
    file = ../secrets/miniflux-credentials.age;
  };

  services.miniflux = {
    enable = true;
    config.LISTEN_ADDR = "0.0.0.0:8080";
    adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
  };
}
