{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.pre-commit-hooks.flakeModule
  ];
  perSystem =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
    {
      formatter = pkgs.nixfmt-tree;
      pre-commit = {
        settings.hooks.treefmt = {
          enable = true;
          stages = [ "pre-push" ];
        };
      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.pre-commit.devShell ];
        packages = [
          pkgs.nixfmt-tree
          pkgs.nixfmt-rfc-style
          inputs'.agenix.packages.agenix
        ];
      };
    };
}
