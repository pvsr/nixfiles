{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  mkHome =
    homeModule:
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.peter = homeModule;
      };
    };
  hostWithModules = lib.types.submodule (
    { name, config, ... }:
    {
      options = {
        modules = lib.mkOption {
          readOnly = true;
          default = [
            ./${name}
            ../modules
            { networking.hostName = name; }
            { nixpkgs.overlays = withSystem config.system ({ pkgs, ... }: pkgs.overlays); }
            { local = { inherit hosts; }; }
          ] ++ lib.optional (config.home != null) (mkHome config.home);
        };
      };
    }
  );
  hosts = config.local.hosts;
in
{
  imports = [ ../modules/hosts.nix ];

  options.local.hosts = lib.mkOption { type = lib.types.attrsOf hostWithModules; };

  config.flake.nixosConfigurations = builtins.mapAttrs (_: host: host.nixos) hosts;
}
