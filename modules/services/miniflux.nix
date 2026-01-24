{
  local.desktops.ruan =
    { config, pkgs, ... }:
    {
      local.endpoints.rss.public = "rss.peterrice.xyz";

      age.secrets."miniflux-credentials" = {
        file = ../hosts/ruan/secrets/miniflux-credentials.age;
      };

      services.miniflux = {
        enable = true;
        config.LISTEN_ADDR = "[${config.local.endpoints.rss.address}]:2808";
        adminCredentialsFile = config.age.secrets."miniflux-credentials".path;
      };

      services.postgresql.package = pkgs.postgresql_16;
      environment.persistence.nixos.directories = [ "/var/lib/postgresql" ];
    };
}
