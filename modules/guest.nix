{ config, ... }:
let
  hosts = config.flake.nixosConfigurations;
  guest = "10.81.157.53";
  forward12262 = dest: port: ''
    chain prerouting {
        type nat hook prerouting priority dstnat
        tcp dport 12262 dnat to ${dest}:${toString port}
    }

    chain postrouting {
        type nat hook postrouting priority srcnat
        ip daddr ${dest} tcp dport ${toString port} masquerade
    }
  '';
in
{
  flake.modules.nixos.crossbell = {
    local.caddy-gateway.reverseProxies."griffin.pvsr.dev" = "ruan.ts.peterrice.xyz:12548";
    networking.nftables.tables.griffin = {
      family = "ip";
      content = forward12262 hosts.ruan.config.local.tailscale.ip 12262;
    };
    networking.firewall.allowedTCPPorts = [ 12262 ];
  };

  flake.modules.nixos.ruan = {
    local.caddy-gateway.reverseProxies.":12548" = guest;
    networking.nftables.tables.griffin = {
      family = "ip";
      content = forward12262 guest 22;
    };
    networking.firewall.allowedTCPPorts = [
      12262
      12548
    ];
  };
}
