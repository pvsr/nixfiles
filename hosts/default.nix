{ inputs, withSystem, ... }:
{
  imports = [
    ./module.nix
    ./arseille
  ];

  local.hosts = {
    grancel = {
      id = 2;
      home = ../home-manager/grancel.nix;
    };
    ruan = {
      id = 3;
      home = ../home-manager/ruan.nix;
    };
    crossbell = {
      id = 1;
      home = ../home-manager/common.nix;
    };
    jurai = {
      id = 5;
      system = "aarch64-linux";
      home = ../home-manager/nixos.nix;
    };
  };
}
