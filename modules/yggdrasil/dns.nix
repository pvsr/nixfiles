{ config, lib, ... }:
let
  domain = "ygg.pvsr.dev";
  nixosConfigurations = lib.filterAttrs (_: host: !host.config.boot.isContainer) (
    config.flake.nixosConfigurations
  );
in
{
  flake.modules.nixos.core = {
    services.resolved.domains = [ domain ];
    networking.nameservers = [ nixosConfigurations.ruan.config.local.ip ];
  };

  flake.modules.nixos.ruan = {
    networking.firewall.interfaces.ygg0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    services.dnsmasq.enable = true;
    services.dnsmasq.resolveLocalQueries = false;
    services.dnsmasq.settings = {
      interface = "ygg0";
      bind-interfaces = true;
      domain-needed = true;
      cache-size = 10000;
      server = [
        "185.71.138.138"
        "2001:67c:930::1"
      ];
      inherit domain;
      local = [ "/${domain}/" ];
      address = lib.mapAttrsToList (
        name: host: "/${name}.${domain}/${host.config.local.ip}"
      ) nixosConfigurations;
    };
  };
}
