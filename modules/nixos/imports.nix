{ inputs, ... }:
let
  modulesPath = "${inputs.nixpkgs}/nixos/modules";
in
{
  flake.modules.nixos = with inputs.self.modules.nixos; {
    base.imports = [
      user
      "${modulesPath}/profiles/minimal.nix"
    ];

    core.imports = [
      base
      inputs.agenix.nixosModules.age
      inputs.disko.nixosModules.disko
    ];

    desktop.imports = [
      yggdrasilClient
      inputs.srvos.nixosModules.desktop
    ];

    container.imports = [
      base
      server
    ];
  };
}
