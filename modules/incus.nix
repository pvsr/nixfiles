{
  flake.modules.nixos.ruan =
    { pkgs, ... }:
    {
      virtualisation.incus.enable = true;
      virtualisation.incus.package = pkgs.incus;

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
