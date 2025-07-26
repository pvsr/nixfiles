{
  flake.modules.nixos.ruan = {
    virtualisation.incus.enable = true;

    local.user.extraGroups = [ "incus-admin" ];

    networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
      53
      67
    ];
    networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
      53
      67
    ];
  };
}
