{ self, lib, ... }:
let
  domain = "ygg.pvsr.dev";
  hosts = lib.filterAttrs (_: host: !host.config.boot.isContainer) self.nixosConfigurations;
  incusHosts = lib.filterAttrs (_: host: host.config.virtualisation.incus.enable) hosts;
in
{
  flake.modules.nixos.core.networking = {
    inherit domain;
    nameservers = lib.mkForce [ hosts.ruan.config.local.ip ];
  };

  local.desktops.ruan.imports = [ self.modules.nixos.yggdrasilNameServer ];
  flake.modules.nixos.yggdrasilNameServer = {
    networking.firewall.interfaces.ygg0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    networking.hosts = lib.mapAttrs' (
      _: host: lib.nameValuePair host.config.local.ip [ host.config.networking.fqdn ]
    ) hosts;

    services.dnsmasq.enable = true;
    services.dnsmasq.resolveLocalQueries = false;
    services.dnsmasq.settings = {
      interface = "ygg0";
      bind-interfaces = true;
      domain-needed = true;
      cache-size = 10000;
      local = [ "/${domain}/" ];
      server = [
        "94.140.14.14"
      ]
      ++ (lib.mapAttrsToList (
        _: host: "/*.${host.config.networking.fqdn}/${host.config.local.prefix}::1"
      ) incusHosts);
    };
  };

  flake.modules.nixos.incus =
    { config, pkgs, ... }:
    {
      networking.firewall.interfaces.ygg0 = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      systemd.services.incus-dns-incusbr0 = {
        description = "Configure DNS for incusbr0";
        wantedBy = [ "sys-subsystem-net-devices-incusbr0.device" ];
        after = [ "sys-subsystem-net-devices-incusbr0.device" ];
        bindsTo = [ "sys-subsystem-net-devices-incusbr0.device" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${pkgs.systemd}/bin/resolvectl dns incusbr0 ${config.local.prefix}::1
          ${pkgs.systemd}/bin/resolvectl domain incusbr0 '~${config.networking.fqdn}'
        '';
        postStop = "${pkgs.systemd}/bin/resolvectl revert incusbr0";
      };
    };
}
