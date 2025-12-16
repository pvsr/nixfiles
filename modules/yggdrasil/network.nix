let
  peerPort = 33933;
  multicastPort = 48147;
in
{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      services.yggdrasil = {
        settings = {
          IfName = "ygg0";
          PrivateKeyPath = "/private-key";
        };
      };

      environment.persistence.nixos.files = [ "/etc/yggdrasil/private.key" ];
      systemd.services.yggdrasil.serviceConfig = lib.mkIf config.services.yggdrasil.enable {
        LoadCredential = "private-key:/etc/yggdrasil/private.key";
        BindReadOnlyPaths = "%d/private-key:/private-key";
      };
    };

  flake.modules.nixos.yggdrasil-client = {
    services.yggdrasil = {
      enable = true;
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
    services.yggdrasil.enable = true;
    services.yggdrasil.settings.Listen = [ "tls://[::]:${toString peerPort}" ];
    networking.firewall.allowedTCPPorts = [ peerPort ];
  };
}
