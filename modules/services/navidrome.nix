{ self, ... }:
let
  internalDomain = self.nixosConfigurations.navidrome.config.networking.fqdn;
in
{
  local.servers.crossbell.local.caddy.reverseProxies."music.pvsr.dev" = internalDomain;

  local.vms.navidrome.host = "grancel";

  local.vms.navidrome.module =
    { config, pkgs, ... }:
    {
      services.navidrome = {
        enable = true;
        settings.Port = 80;
        settings.Address = "[::]";
        settings.MusicFolder = "/var/lib/navidrome/annex/music";
      };

      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
      networking.firewall.allowedTCPPorts = [ 80 ];

      microvm.mem = 768;
      microvm.shares = [
        {
          source = "/home/peter/annex";
          mountPoint = "/var/lib/navidrome/annex";
          tag = "music";
          proto = "virtiofs";
        }
      ];
    };
}
