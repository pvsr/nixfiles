{ inputs, ... }:
{
  local.servers.crossbell.local.caddy.reverseProxies."music.pvsr.dev" =
    "music.${inputs.self.nixosConfigurations.ruan.config.networking.fqdn}";

  local.containers."music.ruan" =
    { config, pkgs, ... }:
    {
      services.navidrome = {
        enable = true;
        settings.Port = 80;
        settings.Address = "[::]";
        settings.MusicFolder = "/var/lib/navidrome/annex/music";
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}
