{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      options.local.containers = lib.mkOption { default = { }; };
      config = lib.mkIf (config.local.containers != { }) {
        boot.enableContainers = true;
        local.impermanence.directories = [ "/var/lib/nixos-containers" ];
        containers = builtins.mapAttrs (_: module: {
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
    };
}
