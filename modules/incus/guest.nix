{ self, ... }:
let
  host = self.nixosConfigurations.ruan.config.networking.fqdn;
  guest = "griff.${host}";
in
{
  local.servers.crossbell =
    { pkgs, ... }:
    {
      local.caddy.reverseProxies."griffin.pvsr.dev" = guest;
      systemd.services.forward-guest-ssh = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:12262,fork,reuseaddr TCP6:${guest}:22";
          Restart = "always";
        };
      };
      networking.firewall.allowedTCPPorts = [ 12262 ];
    };
}
