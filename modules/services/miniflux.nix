{
  local.desktops.ruan =
    { config, ... }:
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
    };
}
