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
      yggdrasil = lib.getExe pkgs.yggdrasil;
      config = pkgs.runCommandLocal "ygg-test-config" { } ''
        ${yggdrasil} -genconf > $out
      '';
      key = pkgs.runCommandLocal "ygg-test-key" { } ''
        cat ${config} | ${yggdrasil} -useconf -exportkey > $out
      '';
      address = pkgs.runCommandLocal "ygg-test-address-module" { } ''
        mkdir $out
        address=$(cat ${config} | ${yggdrasil} -useconf -address)
        printf '"%s"' $address > $out/default.nix
      '';
    in
    {
      local.ip = import "${address}";
      services.yggdrasil.settings = {
        Peers = lib.mkForce [ ];
        PrivateKeyPath = lib.mkForce key;
      };
    };
}
