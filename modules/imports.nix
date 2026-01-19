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

    container.imports = [
      base
    ];

    server.imports = [
      core
      yggdrasilGateway
      inputs.srvos.nixosModules.server
    ];

    desktop.imports = [
      core
      yggdrasilClient
      inputs.srvos.nixosModules.desktop
    ];
  };
}
