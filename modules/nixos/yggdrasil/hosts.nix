{ self, lib, ... }:
let
  hosts = {
    grancel = {
      address = "201:a12b:2097:a213:47ed:1f0b:cce6:46dd";
      publicKey = "57b537da177b2e04b83d0cc66e48b30dba54bbcd6d5f3188c84d7728700045c1";
    };
    ruan = {
      address = "200:dd90:024b:7a11:4a77:edd9:b7f0:0747";
      publicKey = "9137feda42f75ac409132407fc5c01cca29daaa843db1a28d05c8cd07f357d46";
    };
    crossbell = {
      address = "200:e0f5:cdcb:2377:b79c:951c:0047:71cd";
      publicKey = "8f85191a6e442431b571ffdc4719200f94206246521835c3399f3cb2c09636e9";
    };
    jurai = {
      address = "202:7e31:de1a:ebed:efc:c07c:f6f2:abc3";
      publicKey = "3039c43ca2825e2067f06121aa878fa25d5c0e3a1a7f74ed56afec67e4798e55";
    };
    arseille.publicKey = "9e01e6718db245dfe61d8afdff062a9fd4bd06dbee16cbeb0803610c1b53bba0";
  };
in
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      options.local = {
        ip = lib.mkOption {
          default = hosts.${config.networking.hostName}.address;
        };
        prefix = lib.mkOption {
          default = "3${builtins.substring 1 17 config.local.ip}";
        };
      };
    };

  flake.modules.nixos.yggdrasilGateway.services.yggdrasil.settings.AllowedPublicKeys =
    map (builtins.getAttr "publicKey") (builtins.attrValues hosts);

  local.servers.crossbell.imports = [ self.modules.nixos.yggdrasilGateway ];
}
