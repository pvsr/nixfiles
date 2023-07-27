{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-23.05;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    utils.url = github:ravensiris/flake-utils-plus/ravensiris/fix-devshell-legacy-packages;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager/release-23.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:lnl7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.url = github:t184256/nix-on-droid;
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "home-manager";
    podcasts.url = github:pvsr/podcasts;
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.inputs.utils.follows = "utils";
    podcasts.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    weather.url = github:pvsr/weather;
    weather.inputs.nixpkgs.follows = "nixpkgs";
    weather.inputs.flake-utils.follows = "utils";
    weather.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    qbpm.url = github:pvsr/qbpm;
    qbpm.inputs.nixpkgs.follows = "nixpkgs";
    qbpm.inputs.flake-utils.follows = "utils";
    qbpm.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    nvim-colorizer.url = github:norcalli/nvim-colorizer.lua;
    nvim-colorizer.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    nixos-hardware,
    utils,
    home-manager,
    darwin,
    agenix,
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
      vimPlugins =
        prev.vimPlugins
        // {
          nvim-colorizer = prev.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-colorizer";
            version = "git";
            src = inputs.nvim-colorizer;
          };
        };
    };
    sharedOverlays = [
      pluginOverlay
      (final: prev: {
        inherit (inputs.qbpm.packages."${prev.system}") qbpm;
        inherit (agenix.packages."${prev.system}") agenix;
      })
    ];
    fishPlugins = with inputs; {
      inherit fish-prompt-pvsr;
    };
    extraSpecialArgs = {
      inherit fishPlugins;
      appFont = "Fantasque Sans Mono";
    };
  in
    utils.lib.mkFlake {
      inherit self inputs;
      inherit sharedOverlays;

      supportedSystems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      channelsConfig.allowUnfree = true;

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        inputs.podcasts.nixosModules.default
        inputs.weather.nixosModules.default
        {
          nix.generateNixPathFromInputs = true;
          nix.generateRegistryFromInputs = true;
          nix.linkInputs = true;
        }

        ./modules/core.nix
        ./modules/nixos.nix
        ./modules/cachix.nix

        ./users/peter.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      hosts = let
        buildHmUserModule = config: {
          home-manager = {
            inherit extraSpecialArgs;
            users.peter = import config;
          };
        };
      in {
        grancel = {
          channelName = "nixpkgs";
          modules = [
            (import ./hosts/grancel)
            (buildHmUserModule ./home-manager/grancel.nix)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ];
        };
        ruan = {
          channelName = "nixpkgs";
          modules = [
            (import ./hosts/ruan)
            (buildHmUserModule ./home-manager/ruan.nix)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ];
        };
        crossbell = {
          channelName = "nixpkgs";
          modules = [
            (import ./hosts/crossbell)
            (buildHmUserModule ./home-manager/common.nix)
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        };
        jurai = {
          channelName = "nixpkgs";
          system = "aarch64-darwin";
          output = "homeConfigurations";

          builder = args:
            home-manager.lib.homeManagerConfiguration {
              inherit extraSpecialArgs;
              pkgs = self.pkgs.${args.system}.nixpkgs;
              modules = [./home-manager/macbook.nix];
            };
        };
        arseille = {
          channelName = "nixpkgs";
          system = "aarch64-linux";
          output = "nixOnDroidConfigurations";

          builder = args:
            inputs.nix-on-droid.lib.nixOnDroidConfiguration {
              system.stateVersion = "22.11";
              home-manager-path = home-manager.outPath;
              pkgs = import nixpkgs {
                inherit (args) system;
                overlays = [inputs.nix-on-droid.overlays.default] ++ sharedOverlays;
              };
              modules = [
                ./hosts/arseille/default.nix
                ({...}: {
                  home-manager = {
                    config = import ./home-manager/arseille.nix;
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    inherit extraSpecialArgs;
                  };
                })
              ];
            };
        };
      };

      outputsBuilder = channels: let
        pkgs = channels.nixpkgs;
        deploy = host: user: (pkgs.writeScriptBin "deploy-${host}" ''
          nixos-rebuild --fast --flake .#${host} --target-host ${user}@${host} --use-remote-sudo switch
        '');
      in {
        formatter = pkgs.alejandra;
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
            src = ./.;
            hooks.alejandra.enable = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
          buildInputs = [
            agenix.packages.${pkgs.system}.agenix
            (deploy "ruan" "peter")
            (deploy "crossbell" "root")
          ];
        };
      };
    };
}
