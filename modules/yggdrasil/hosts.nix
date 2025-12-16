{ lib, ... }:
let
  hosts = {
    grancel = {
      address = "201:a12b:2097:a213:47ed:1f0b:cce6:46dd";
      publicKey = "57b537da177b2e04b83d0cc66e48b30dba54bbcd6d5f3188c84d7728700045c1";
    };
    ruan = {
      address = "200:dd90:24b:7a11:4a77:edd9:b7f0:747";
      publicKey = "9137feda42f75ac409132407fc5c01cca29daaa843db1a28d05c8cd07f357d46";
    };
    crossbell = {
      address = "200:b270:40a1:984:2710:a9c7:b346:4b83";
      publicKey = "a6c7dfaf7b3dec77ab1c265cda3e05410db6375fb7bc1ef89d6c6008ce5ef493";
    };
    jurai = {
      address = "202:7e31:de1a:ebed:efc:c07c:f6f2:abc3";
      publicKey = "3039c43ca2825e2067f06121aa878fa25d5c0e3a1a7f74ed56afec67e4798e55";
    };
  };
in
{
  flake.modules.nixos.core =
    { config, ... }:
    {
      options.local.ip = lib.mkOption {
        default = hosts."${config.networking.hostName}".address;
      };

      config.networking = {
        hosts = lib.mapAttrs' (
          hostname:
          { address, ... }:
          {
            name = address;
            value = [ "${hostname}.ygg.pvsr.dev" ];
          }
        ) hosts;
        firewall.interfaces.ygg0.allowedTCPPorts = [ 22 ];
      };
    };

  flake.modules.nixos.yggdrasil-gateway.services.yggdrasil.settings.AllowedPublicKeys =
    map (builtins.getAttr "publicKey") (builtins.attrValues hosts);
}
