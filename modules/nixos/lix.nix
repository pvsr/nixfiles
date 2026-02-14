{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nix.package = pkgs.lixPackageSets.latest.lix;
    };
}
