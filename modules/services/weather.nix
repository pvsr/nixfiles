{ inputs, ... }:
{
  local.desktops.ruan =
    { config, ... }:
    let
      endpoint = config.local.endpoints.rss;
    in
    {
      imports = [ inputs.weather.nixosModules.default ];

      local.endpoints.weather.public = "weather.peterrice.xyz";

      services = {
        weather.enable = true;
        weather.bind = "[${endpoint.address}]:${toString endpoint.port}";
      };
    };
}
