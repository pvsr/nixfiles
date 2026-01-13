let
  peerPort = 33933;
  multicastPort = 48147;
  keyPath = "/etc/yggdrasil/private.pem";
in
{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      services.yggdrasil = {
        enable = !config.boot.isContainer;
        settings.IfName = "ygg0";
        settings.PrivateKeyPath = keyPath;
      };

      environment.persistence.nixos.files = [ keyPath ];
    };

  flake.modules.nixos.yggdrasil-client = {
    services.yggdrasil = {
      openMulticastPort = true;
      settings = {
        Peers = [ "tls://internal.pvsr.dev:${toString peerPort}" ];
        MulticastInterfaces = [
          {
            Regex = "en.*";
            Port = multicastPort;
          }
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [ multicastPort ];
  };

  flake.modules.nixos.yggdrasil-gateway = {
    services.yggdrasil.settings.Listen = [ "tls://[::]:${toString peerPort}" ];
    networking.firewall.allowedTCPPorts = [ peerPort ];
  };
}
