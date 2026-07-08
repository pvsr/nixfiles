{ lib, ... }:
{
  flake.modules.nixos.base = {
    networking.firewall.enable = lib.mkDefault true;
    networking.nftables.enable = true;

    services.openssh = {
      openFirewall = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
      };
    };

    networking.nameservers = [ "94.140.14.14" ];
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
