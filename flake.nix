{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "unstable";
    impermanence.url = "github:nix-community/impermanence";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
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
    jj.url = "github:martinvonz/jj";
    jj.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";

    # sources
    srcery-tmux.url = "github:srcery-colors/srcery-tmux";
    srcery-tmux.flake = false;
    fish-prompt-pvsr.url = "github:pvsr/fish-prompt-pvsr";
    fish-prompt-pvsr.flake = false;
  };

  outputs =
    inputs:
    let
      overlays = [
        (import ./overlay.nix inputs)
        inputs.niri.overlays.niri
      ];
      specialArgs.inputs = inputs;
      specialArgs.appFont = "Fantasque Sans Mono";
      extraSpecialArgs = specialArgs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.pre-commit-hooks.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake.nixosConfigurations = builtins.mapAttrs (
        hostName: hostModule:
        inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            hostModule
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.age
            {
              nixpkgs = {
                inherit overlays;
              };
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.peter = ./home-manager/${hostName}.nix;
              };
            }
            ./modules/nix.nix
            ./modules/nixos.nix
            ./users/peter.nix
          ];
        }
      ) (import ./hosts);

      flake.nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        inherit extraSpecialArgs;
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [ inputs.nix-on-droid.overlays.default ] ++ overlays;
        };
        home-manager-path = inputs.home-manager.outPath;
        modules = [
          ./hosts/arseille
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraSpecialArgs;
            home-manager.config = ./home-manager/arseille.nix;
          }
        ];
      };

      perSystem =
        {
          config,
          pkgs,
          unstablePkgs,
          system,
          self',
          inputs',
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs { inherit system overlays; };
          _module.args.unstablePkgs = import inputs.unstable { inherit system overlays; };
          legacyPackages.homeConfigurations.valleria = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs extraSpecialArgs;
            modules = [ ./home-manager/valleria.nix ];
          };
          legacyPackages.homeConfigurations.jurai = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs extraSpecialArgs;
            modules = [ ./home-manager/macbook.nix ];
          };

          packages.deploy = pkgs.writeScriptBin "deploy" ''
            #!${pkgs.fish}/bin/fish
            argparse -n deploy -X 1 'c/command=' -- $argv; or return
            set command (printf $_flag_command; or printf switch)
            set host (printf $argv; or hostname)
            nixos-rebuild --fast --flake "/etc/nixos#$host" --target-host $host --use-remote-sudo $command
          '';

          formatter = pkgs.nixfmt-rfc-style;
          pre-commit = {
            settings.hooks.nixfmt-rfc-style = {
              enable = true;
              stages = [ "pre-push" ];
            };
          };
          devShells.default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];
            buildInputs = [
              self'.packages.deploy
              inputs'.agenix.packages.agenix
            ];
          };
        };
    };
}
