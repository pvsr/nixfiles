{ lib, ... }:
let
  peerPort = 33933;
  multicastPort = 48147;
  keyPath = "/etc/yggdrasil/private.pem";
in
{
  flake.modules.nixos.core =
    { config, ... }:
    {
      services.yggdrasil = {
        enable = !config.boot.isContainer;
        settings.IfName = "ygg0";
        settings.PrivateKeyPath = keyPath;
      };

      environment.persistence.nixos.files = [ keyPath ];
      networking.firewall.interfaces.ygg0.allowedTCPPorts = [ 22 ];
      networking.firewall.allowedTCPPorts = [ 2808 ];

      local.testScript = "machine.wait_for_unit('yggdrasil.service')";
    };

  flake.modules.nixos.yggdrasilClient = {
    services.yggdrasil = {
      openMulticastPort = true;
      settings = {
        Peers = [ "tls://internal.pvsr.dev:${toString peerPort}" ];
        MulticastInterfaces = [
          {
            Regex = "e(n|th).*";
            Port = multicastPort;
          }
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [ multicastPort ];
  };

  flake.modules.nixos.yggdrasilGateway = {
    services.yggdrasil.settings.Listen = [ "tls://[::]:${toString peerPort}" ];
    networking.firewall.allowedTCPPorts = [ peerPort ];
  };

  flake.modules.nixos.test =
    { pkgs, ... }:
    let
      ygg = lib.getExe pkgs.yggdrasil;
    in
    {
      services.yggdrasil.settings = {
        Peers = lib.mkForce [ ];
        PrivateKeyPath = lib.mkForce (
          pkgs.runCommandLocal "export-test-key" { } "${ygg} -genconf | ${ygg} -useconf -exportkey > $out"
        );
      };
    };
}
