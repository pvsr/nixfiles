{
  flake.modules.nixos.core =
    { lib, config, ... }:
    let
      bridge = "microvm";
    in
    {
      config = lib.mkIf (config.microvm.host.enable) {
        networking.bridges.${bridge}.interfaces = [ ];

        systemd.network.networks."10-${bridge}" = {
          matchConfig.Name = bridge;
          dns = [ "${config.local.prefix}::1" ];
          domains = [ "~${config.networking.fqdn}" ];
          addresses = [ { Address = "${config.local.prefix}::1/64"; } ];
          ipv6Prefixes = [ { Prefix = "${config.local.prefix}::/64"; } ];
        };

        systemd.network.networks."11-${bridge}" = {
          matchConfig.Name = "vm-*";
          networkConfig.Bridge = bridge;
        };

        services.dnsmasq.enable = true;
        services.dnsmasq.resolveLocalQueries = false;
        services.dnsmasq.settings = {
          bind-dynamic = true;
          domain-needed = true;
          no-resolv = true;
          no-hosts = true;
          domain = config.networking.fqdn;
          local = "/${config.networking.fqdn}/";
          enable-ra = true;
          dhcp-range = "::2,::ff,constructor:${bridge}";
        };

        networking.firewall.allowedUDPPorts = [
          53
          547
        ];
      };
    };
}
