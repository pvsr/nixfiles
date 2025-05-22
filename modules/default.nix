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
  imports = (builtins.filter isModule (lib.filesystem.listFilesRecursive ./.)) ++ [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];

  environment.systemPackages = [ (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish)) ];
}
