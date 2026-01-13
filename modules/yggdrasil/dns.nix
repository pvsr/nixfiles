{ config, lib, ... }:
let
  domain = "ygg.pvsr.dev";
  hosts = lib.filterAttrs (_: host: !host.config.boot.isContainer) config.flake.nixosConfigurations;
  incusHosts = lib.filterAttrs (_: host: host.config.virtualisation.incus.enable) (hosts);
in
{
  flake.modules.nixos.core = {
    services.resolved.domains = [ domain ];
    networking.nameservers = [ hosts.ruan.config.local.ip ];
  };

  flake.modules.nixos.grancel = {
    networking.firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };
  flake.modules.nixos.ruan = {
    networking.firewall.interfaces.ygg0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    networking.hosts = lib.mapAttrs' (
      name: host: lib.nameValuePair host.config.local.ip [ "${name}.${domain}" ]
    ) hosts;

    services.dnsmasq.enable = true;
    services.dnsmasq.resolveLocalQueries = false;
    services.dnsmasq.settings = {
      interface = "ygg0";
      bind-interfaces = true;
      domain-needed = true;
      cache-size = 10000;
      local = [ "/${domain}/" ];
      filter-A = true;
      server = [
        "185.71.138.138"
        "2001:67c:930::1"
      ]
      ++ (lib.mapAttrsToList (
        name: host: "/*.${name}.${domain}/${host.config.local.prefix}::1"
      ) incusHosts);
    };
  };
}
