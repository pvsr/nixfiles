{ inputs, withSystem, ... }:
{
  flake.nixOnDroidConfigurations.default = withSystem "aarch64-linux" (
    { system, pkgs, ... }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = pkgs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
      modules = [ inputs.self.modules.nixOnDroid.arseille ];
    }
  );
}
