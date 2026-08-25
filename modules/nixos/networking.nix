{ lib, ... }:
{
  flake.modules.nixos.base = {
    networking.firewall.enable = lib.mkDefault true;
    networking.nftables.enable = true;

    services.openssh = {
      openFirewall = lib.mkDefault false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
      };
    };
  };

  flake.modules.nixos.core = {
    services.openssh.enable = true;
  };

  flake.modules.nixos.desktop =
    { config, ... }:
    {
      networking.firewall.interfaces.${config.local.ethernetInterface}.allowedTCPPorts = [ 22 ];
    };
}
