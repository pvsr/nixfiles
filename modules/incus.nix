{ self, ... }:
{
  flake.modules.nixos.grancel.imports = [ self.modules.nixos.incus ];
  flake.modules.nixos.ruan.imports = [ self.modules.nixos.incus ];
  flake.modules.nixos.incus =
    { config, pkgs, ... }:
    {
      virtualisation.incus.enable = true;
      virtualisation.incus.package = pkgs.incus;

      # TODO declarative setup for incus should include:
      # ipv6.address = "${config.local.prefix}/64";
      # dns.domain = config.networking.hostName;
      # raw.dnsmasq = "domain=${config.networking.hostName}.ygg.pvsr.dev";

      local.user.extraGroups = [ "incus-admin" ];

      networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
        53
        67
      ];
      networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
        53
        67
      ];

      environment.persistence.nixos.directories = [ "/var/lib/incus" ];
    };
}
