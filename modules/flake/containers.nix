{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.modules.nixos) container hostContainer;
  cfg = config.local;
  mkHostname =
    containerName:
    let
      parts = lib.splitString "." containerName;
      host = config.flake.nixosConfigurations.${lib.last parts};
    in
    {
      networking.hostName = lib.head parts;
      networking.domain = host.config.networking.fqdn;
    };
  mkHost = sharedModule: name: hostModule: {
    imports = [
      hostModule
      sharedModule
      (mkHostname name)
    ];
  };
  mkHosts = sharedModule: builtins.mapAttrs (mkHost sharedModule);
  hostContainers = mkHosts hostContainer (
    lib.mapAttrs' (name: lib.nameValuePair "${name}.grancel") cfg.hosts
  );
in
{
  options.local = {
    containers = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = { };
    };
    resolvedContainers = lib.mkOption {
      readOnly = true;
      default = mkHosts container cfg.containers;
    };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    _: module: lib.nixosSystem { modules = [ module ]; }
  ) (cfg.resolvedContainers // hostContainers);
}
