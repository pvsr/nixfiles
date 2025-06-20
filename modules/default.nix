{ inputs, ... }:
{
  flake.modules.nixos.core.imports = [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];
}
