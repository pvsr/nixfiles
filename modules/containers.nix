{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:
{
  options.local.containers = lib.mkOption { default = { }; };
  config = lib.mkIf (config.local.containers != { }) {
    local.impermanence.directories = [ "/var/lib/nixos-containers" ];
    containers = builtins.mapAttrs (_: module: {
      specialArgs.inputs = inputs;
      autoStart = true;
      config.imports = [
        module
        "${modulesPath}/profiles/minimal.nix"
        {
          system.stateVersion = config.system.stateVersion;
          users.defaultUserShell = pkgs.fishMinimal;
        }
      ];
    }) config.local.containers;
  };
}
