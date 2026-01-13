{ self, ... }:
{
  flake.modules.nixos.grancel.imports = [ self.modules.nixos.incus ];
  flake.modules.nixos.ruan.imports = [ self.modules.nixos.incus ];
  flake.modules.nixos.incus =
    { config, pkgs, ... }:
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
          ${pkgs.systemd}/bin/resolvectl domain incusbr0 '~incus'
        '';
        postStop = "${pkgs.systemd}/bin/resolvectl revert incusbr0";
      };
    };
}
