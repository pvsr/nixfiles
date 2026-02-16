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
      local.testScript = ''
        machine.succeed("mkdir -p /var/lib/navidrome/annex/music")
        machine.wait_for_unit("navidrome.service")
        machine.wait_for_open_port(80)
      '';
    };
}
