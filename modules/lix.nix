{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nix.package = pkgs.lixPackageSets.stable.lix;
    };
}
