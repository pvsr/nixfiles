{ lib, ... }:
{
  options.local.appFont = lib.mkOption {
    type = lib.types.str;
    default = "Fantasque Sans Mono";
  };
}
