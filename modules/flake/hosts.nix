{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.modules.nixos) core desktop server;
  cfg = config.local;
  mkHost = sharedModule: name: hostModule: {
    imports = [
      core
      sharedModule
      hostModule
    ];
    networking.hostName = name;
    hjem.extraModules = [ inputs.self.modules.hjem.${name} or { } ];
  };
  mkHosts = sharedModule: builtins.mapAttrs (mkHost sharedModule);
in
{
  options.local = {
    desktops = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = { };
    };
    servers = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = { };
    };
    hosts = lib.mkOption {
      readOnly = true;
      default = mkHosts desktop cfg.desktops // mkHosts server cfg.servers;
    };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    name: module: lib.nixosSystem { modules = [ module ]; }
  ) cfg.hosts;
}
