{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.modules.nixos) container hostContainer;
  cfg = config.local;
  mkHost = sharedModule: name: hostModule: {
    modules = [
      hostModule
      (sharedModule name)
    ];
  };
  mkHosts = sharedModule: builtins.mapAttrs (mkHost sharedModule);
  containers = mkHosts (name: {
    imports = [ container ];
    networking.hostName = lib.head (lib.splitString "." name);
  }) cfg.containers;
  hostContainers = lib.mapAttrs' (name: lib.nameValuePair "${name}.incus") (
    mkHosts (_: hostContainer) cfg.hosts
  );
in
{
  options.local.containers = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (_: lib.nixosSystem) (
    containers // hostContainers
  );
}
