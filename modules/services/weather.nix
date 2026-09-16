{ inputs, ... }:
{
  local.desktops.ruan = {
    imports = [ inputs.weather.nixosModules.default ];
    services.weather.enable = true;
    environment.persistence.nixos.directories = [ "/etc/weather" ];
  };
}
