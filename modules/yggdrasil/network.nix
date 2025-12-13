{ lib, ... }:
let
  peerPort = 33933;
  multicastPort = 48147;
  IfName = "ygg0";
  PrivateKeyPath = "/private-key";
in
{
  flake.modules.nixos.core = {
    services.yggdrasil = {
      enable = true;
      openMulticastPort = true;
      settings = lib.mkDefault {
        inherit IfName PrivateKeyPath;
        Peers = [ "tls://104.238.130.11:${toString peerPort}" ];
        MulticastInterfaces = [
          {
            Regex = "en.*";
            Port = multicastPort;
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ multicastPort ];
    environment.persistence.nixos.files = [ "/etc/yggdrasil/private.key" ];
    systemd.services.yggdrasil.serviceConfig.LoadCredential = "private-key:/etc/yggdrasil/private.key";
    systemd.services.yggdrasil.serviceConfig.BindReadOnlyPaths = "%d/private-key:/private-key";
  };

  flake.modules.nixos.gateway = {
    services.yggdrasil.settings = {
      inherit IfName PrivateKeyPath;
      Peers = [ ];
      MulticastInterfaces = [ ];
      Listen = [ "tls://[::]:${toString peerPort}" ];
    };
    networking.firewall.allowedTCPPorts = [ peerPort ];
  };
}
