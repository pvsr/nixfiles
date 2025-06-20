{ inputs, ... }:
{
  flake.modules.nixos.server.imports = [
    inputs.srvos.nixosModules.server
    inputs.self.modules.nixos.gateway
  ];
}
