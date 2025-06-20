{ lib, ... }:
{
  flake.modules.nixos = {
    core.options.local.id = lib.mkOption { type = lib.types.ints.u8; };
    crossbell.local.id = 1;
    grancel.local.id = 2;
    ruan.local.id = 3;
    jurai.local.id = 5;
  };
}
