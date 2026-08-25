{
  lib,
  self,
  config,
  ...
}:
let
  inherit (config) router;
in
{
  flake.modules.nixos.core =
    { config, ... }:
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
          addresses = [
            { Address = "10.0.0.1/24"; }
            { Address = "${config.local.prefix}::1/64"; }
          ];
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
          server = [ router.ip ];
          enable-ra = true;
          dhcp-range = [
            "10.0.0.2,10.0.0.255"
            "::2,::ff,constructor:${bridge}"
          ];
        };

        networking.firewall.allowedUDPPorts = [
          53
          67
          547
        ];

        networking.firewall.interfaces.${bridge}.allowedTCPPorts = [ 22 ];

        networking.nat = {
          enable = true;
          enableIPv6 = true;
          externalInterface = config.local.ethernetInterface;
          internalInterfaces = [ bridge ];
        };
      };
    };

  router.servers =
    self.nixosConfigurations
    |> lib.filterAttrs (_: host: !(host.config ? microvm && host.config.microvm ? guest))
    |> lib.filterAttrs (_: host: host.config.microvm.host.enable)
    |> lib.mapAttrsToList (
      _: host: "/*.${host.config.networking.fqdn}/${host.config.local.prefix}::1/"
    );
}
