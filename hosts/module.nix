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
  hosts = builtins.mapAttrs (name: host: rec {
    modules = [
      ./${name}
      ../modules
      {
        local.id = host.id;
        networking.hostName = name;
        nixpkgs.system = host.system;
        nixpkgs.overlays = withSystem host.system ({ pkgs, ... }: pkgs.overlays);
      }
    ] ++ lib.optional (host.home != null) (mkHome host.home);
    nixos = inputs.nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = { inherit inputs hosts; };
    };
  }) config.local.hosts;
in
{
  options.local.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          id = lib.mkOption { type = lib.types.ints.u8; };
          system = lib.mkOption { default = "x86_64-linux"; };
          home = lib.mkOption { type = lib.types.nullOr lib.types.path; };
        };
      }
    );
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (_: builtins.getAttr "nixos") hosts;
}
