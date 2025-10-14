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
  };

  flake.modules.nixos.core = {
    networking.nameservers = [ "94.140.14.14" ];

    services.openssh.enable = true;
    networking.firewall.interfaces.enp8s0.allowedTCPPorts = [ 22 ];
    networking.firewall.interfaces.enp37s0.allowedTCPPorts = [ 22 ];
  };
}
