{ inputs, ... }:
let
  hjemModule =
    { config, ... }:
    {
      hjem.users.${config.local.username}.enable = true;
      hjem.extraModules = [ inputs.self.modules.hjem.core ];
    };
in
{
  flake.modules.nixos.core = {
    imports = [
      hjemModule
      inputs.hjem.nixosModules.hjem
    ];
    environment.persistence.nixos.directories = [ "/var/lib/hjem" ];
  };
  flake.modules.darwin.default = {
    imports = [
      hjemModule
      inputs.hjem.darwinModules.hjem
    ];
  };
}
