{ inputs, ... }:
let
  hjemModule =
    { config, ... }:
    {
      hjem.users.${config.local.user.name}.enable = true;
      hjem.extraModules = [ inputs.self.modules.hjem.core ];
    };
in
{
  flake.modules.nixos.core = {
    imports = [
      hjemModule
      inputs.hjem.nixosModules.hjem
    ];
  };
  flake.modules.darwin.default = {
    imports = [
      hjemModule
      inputs.hjem.darwinModules.hjem
    ];
  };
}
