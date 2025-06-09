{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  isModule = (f: lib.hasSuffix ".nix" f && f != ./default.nix);
in
{
  options.local.id = lib.mkOption { type = lib.types.ints.u8; };

  imports = (builtins.filter isModule (lib.filesystem.listFilesRecursive ./.)) ++ [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];

  config.environment.systemPackages = [
    (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish))
  ];
}
