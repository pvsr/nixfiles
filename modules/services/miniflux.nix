{ lib, ... }:
{
  local.desktops.ruan =
    { config, pkgs, ... }:
    let
      endpoint = config.local.endpoints.rss;
    in
    {
      local.endpoints.rss.public = "rss.peterrice.xyz";

      age.secrets."miniflux-credentials" = {
        file = ../hosts/ruan/secrets/miniflux-credentials.age;
      };

      services.miniflux = {
        enable = true;
        config.LISTEN_ADDR = "[${endpoint.address}]:${toString endpoint.port}";
        adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
      };

      services.postgresql.package = pkgs.postgresql_16;
      environment.persistence.nixos.directories = [ "/var/lib/postgresql" ];
    };

  flake.modules.nixos.test.services.miniflux.enable = lib.mkForce false;
}
