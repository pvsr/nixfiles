{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "unstable";
    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.url = "github:nix-community/nix-on-droid";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "unstable";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs";
    podcasts.url = "github:pvsr/podcasts";
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    weather.url = "github:pvsr/weather";
    weather.inputs.nixpkgs.follows = "nixpkgs";
    weather.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    qbpm.url = "github:pvsr/qbpm";
    qbpm.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";

    # sources
    srcery-tmux.url = "github:srcery-colors/srcery-tmux";
    srcery-tmux.flake = false;
    fish-prompt-pvsr.url = "github:pvsr/fish-prompt-pvsr";
    fish-prompt-pvsr.flake = false;
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        inputs.pre-commit-hooks.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          self',
          inputs',
          ...
        }:
        {
          _module.args.pkgs = import inputs.unstable {
            inherit system;
            overlays = [
              (import ./overlay.nix inputs)
            ];
          };

          apps = pkgs.lib.mapAttrs' (host: nixosConfig: {
            name = "${host}-vm";
            value = {
              type = "app";
              program = pkgs.lib.getExe (
                if nixosConfig.config.disko.devices.disk != { } then
                  nixosConfig.config.system.build.vmWithDisko
                else
                  nixosConfig.config.system.build.vm
              );
            };
          }) inputs.self.nixosConfigurations;

          legacyPackages.homeConfigurations = import ./home-manager { inherit system inputs pkgs; };

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
              inputs'.agenix.packages.agenix
            ];
          };
          devShells.python = pkgs.mkShell {
            packages = with pkgs; [
              uv
              ruff
              (python3.withPackages (
                ps: with ps; [
                  mypy
                  pylsp-mypy
                ]
              ))
            ];
          };
        };
    };
}
