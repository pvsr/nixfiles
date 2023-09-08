{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-23.05;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager/release-23.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.url = github:t184256/nix-on-droid;
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    podcasts.url = github:pvsr/podcasts;
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    weather.url = github:pvsr/weather;
    weather.inputs.nixpkgs.follows = "nixpkgs";
    weather.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    qbpm.url = github:pvsr/qbpm;
    qbpm.inputs.nixpkgs.follows = "nixpkgs";
    qbpm.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    home-manager,
    ...
  }: let
    pluginOverlay = final: prev: {
      tmuxPlugins =
        prev.tmuxPlugins
        // {
          srcery = prev.tmuxPlugins.mkTmuxPlugin {
            pluginName = "srcery";
            version = "git";
            src = inputs.srcery-tmux;
          };
        };
      fishPlugins =
        prev.fishPlugins
        // {
          fish-prompt-pvsr = prev.fishPlugins.buildFishPlugin {
            pname = "fish-prompt-pvsr";
            version = "git";
            src = inputs.fish-prompt-pvsr;
          };
        };
    };
    overlays = [
      pluginOverlay
      (final: prev: let
        system = prev.stdenv.hostPlatform.system;
        unstable = inputs.unstable.legacyPackages.${system};
      in {
        inherit (inputs.qbpm.packages.${system}) qbpm;
        inherit (inputs.agenix.packages.${system}) agenix;
        inherit (unstable) foot;
        transmission = unstable.transmission_4;
      })
    ];
    specialArgs.flake = {inherit self inputs;};
    extraSpecialArgs =
      specialArgs
      // {
        appFont = "Fantasque Sans Mono";
      };
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      flake.nixosModules = {
        core = import ./modules/core.nix;
        nixos = import ./modules/nixos.nix;
        cachix = import ./modules/cachix.nix;

        grancel = import ./hosts/grancel;
        ruan = import ./hosts/ruan;
        crossbell = import ./hosts/crossbell;

        peter = import ./users/peter.nix;
        home-manager = {
          pkgs,
          config,
          ...
        }: {
          imports = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraSpecialArgs;
              home-manager.users.peter = import ./home-manager/${config.networking.hostName}.nix;
            }
          ];
        };
      };

      flake.nixosConfigurations = let
        mkNixosSystem = imports:
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = [
              {
                inherit imports;
                nixpkgs = {
                  inherit overlays;
                  hostPlatform = "x86_64-linux";
                };
              }
              self.nixosModules.core
              self.nixosModules.nixos
              self.nixosModules.cachix
              self.nixosModules.peter
              self.nixosModules.home-manager
              inputs.agenix.nixosModules.age
            ];
          };
      in {
        grancel = mkNixosSystem [
          self.nixosModules.grancel
        ];
        ruan = mkNixosSystem [
          self.nixosModules.ruan
          inputs.podcasts.nixosModules.default
          inputs.weather.nixosModules.default
        ];
        crossbell = mkNixosSystem [
          self.nixosModules.crossbell
        ];
      };

      flake.legacyPackages.aarch64-linux.nixOnDroidConfigurations.arseille = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          overlays = [inputs.nix-on-droid.overlays.default] ++ overlays;
          system = "aarch64-linux";
        };
        system.stateVersion = "22.11";
        home-manager-path = home-manager.outPath;
        modules = [
          ./hosts/arseille
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraSpecialArgs;
            home-manager.config = import ./home-manager/arseille.nix;
          }
        ];
      };

      perSystem = {
        pkgs,
        system,
        self',
        inputs',
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system overlays;
        };
        legacyPackages.homeConfigurations.jurai = home-manager.lib.homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = [{imports = [./home-manager/macbook.nix];}];
        };

        formatter = pkgs.alejandra;
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.alejandra.enable = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;
          buildInputs = let
            deploy = host: user: (pkgs.writeScriptBin "deploy-${host}" ''
              nixos-rebuild --fast --flake .#${host} --target-host ${user}@${host} --use-remote-sudo switch
            '');
          in [
            inputs'.agenix.packages.agenix
            (deploy "ruan" "peter")
            (deploy "crossbell" "root")
          ];
        };
      };
    };
}
