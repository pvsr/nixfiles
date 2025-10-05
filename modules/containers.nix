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
        environment.persistence.nixos.directories = [ "/var/lib/nixos-containers" ];
        containers = lib.mkMerge [
          config.local.containers
          (builtins.mapAttrs (_: _: {
            config.imports = [
              "${modulesPath}/profiles/minimal.nix"
              {
                system.stateVersion = config.system.stateVersion;
                users.defaultUserShell = pkgs.fishMinimal;
              }
            ];
          }) config.local.containers)
        ];
      };
    };
}
