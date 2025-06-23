{ self, inputs, ... }:
{
  flake.modules.homeManager.standalone = {
    imports = [ self.modules.homeManager.core ];
    home.stateVersion = "25.05";
    nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
  };
}
