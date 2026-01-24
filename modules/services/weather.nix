{ inputs, ... }:
{
  local.desktops.ruan =
    { config, ... }:
    {
      imports = [ inputs.weather.nixosModules.default ];

      local.endpoints.weather.public = "weather.peterrice.xyz";

      services = {
        weather.enable = true;
        weather.bind = "[${config.local.endpoints.weather.address}]:2808";
      };
    };
}
