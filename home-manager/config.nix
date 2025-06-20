{ lib, ... }:
{
  flake.modules.homeManager.core.options.local.appFont = lib.mkOption {
    type = lib.types.str;
    default = "Fantasque Sans Mono";
  };
}
