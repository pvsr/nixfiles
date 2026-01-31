{ self, lib, ... }:
let
  domain = "ygg.pvsr.dev";
  hosts = lib.filterAttrs (_: host: !host.config.boot.isContainer) self.nixosConfigurations;
  incusHosts = lib.filterAttrs (_: host: host.config.virtualisation.incus.enable) hosts;
in
{
  flake.modules.nixos.core.networking = {
    domain = lib.mkDefault domain;
    search = [ domain ];
    nameservers = lib.mkForce [ hosts.ruan.config.local.ip ];
  };

  flake.modules.nixos.yggdrasilNameServer = {
    networking.firewall.interfaces.ygg0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    networking.hosts =
      lib.mapAttrs' (
        _: host: lib.nameValuePair host.config.local.ip [ host.config.networking.fqdn ]
      ) hosts
      // {
        "127.0.0.2" = lib.mkForce [ ];
      };

    services.dnsmasq.enable = true;
    services.dnsmasq.resolveLocalQueries = false;
    services.dnsmasq.settings = {
      interface = "ygg0";
      bind-interfaces = true;
      domain-needed = true;
      cache-size = 10000;
      local = [ "/${domain}/" ];
      no-resolv = true;
      server = [
        "94.140.14.14"
      ]
      ++ (lib.mapAttrsToList (
        _: host: "/*.${host.config.networking.fqdn}/${host.config.local.prefix}::1"
      ) incusHosts);
    };
  };

  local.desktops.ruan =
    { config, pkgs, ... }:
    {
      imports = [ self.modules.nixos.yggdrasilNameServer ];
      local.testScript = ''
        machine.wait_for_unit("dnsmasq.service")
        address = machine.succeed("yggdrasilctl -json getself | ${pkgs.jq}/bin/jq -r .address").strip()
        t.assertIn(address, machine.succeed(f"dig @{address} ${config.networking.fqdn} AAAA"))
        machine.succeed(f"dig @{address} ${hosts.grancel.config.networking.fqdn} AAAA")
      '';
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
