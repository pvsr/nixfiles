{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
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
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt
          pkgs.nixfmt-tree
          inputs'.agenix.packages.agenix
        ];
      };
    };
}
