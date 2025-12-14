{ config, ... }:
let
  ruan = config.flake.nixosConfigurations.ruan.config.local.ip;
  guest = "10.81.157.53";
in
{
  flake.modules.nixos.crossbell =
    { pkgs, ... }:
    {
      local.caddy.reverseProxies."griffin.pvsr.dev" = "ruan.ygg.pvsr.dev:12548";
      systemd.services.forward-guest-ssh = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:12262,fork,reuseaddr TCP6:[${ruan}]:12262";
          Restart = "always";
        };
      };
      networking.firewall.allowedTCPPorts = [
        12262
      ];
    };

  flake.modules.nixos.ruan =
    { pkgs, ... }:
    {
      local.caddy.reverseProxies.":12548" = guest;
      systemd.services.forward-guest-ssh = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP6-LISTEN:12262,fork,reuseaddr TCP4:${guest}:22";
          Restart = "always";
        };
      };
      networking.firewall.allowedTCPPorts = [
        12548
        12262
      ];
    };
}
