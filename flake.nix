{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-22.11;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager/release-22.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:lnl7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.url = github:pvsr/podcasts;
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    qbpm.url = github:pvsr/qbpm;
    qbpm.inputs.nixpkgs.follows = "nixpkgs";

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    nvim-colorizer.url = github:norcalli/nvim-colorizer.lua;
    nvim-colorizer.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
    fish-plugin-git.url = github:jhillyerd/plugin-git;
    fish-plugin-git.flake = false;
    fish-async-prompt.url = github:acomagu/fish-async-prompt;
    fish-async-prompt.flake = false;
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
      inherit fish-prompt-pvsr fish-async-prompt;
      plugin-git = fish-plugin-git;
    };
    extraSpecialArgs = {
      inherit fishPlugins;
      appFont = "Fantasque Sans Mono";
    };
  in
    utils.lib.mkFlake {
      inherit self inputs;
      inherit sharedOverlays;

      supportedSystems = ["x86_64-linux" "aarch64-darwin"];

      channelsConfig.allowUnfree = true;
      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {inherit (channels.unstable) helix yambar spotifyd;})
      ];

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        inputs.podcasts.nixosModules.default
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

      hosts = {
        grancel = {
          channelName = "nixpkgs";
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/grancel.nix;
                inherit extraSpecialArgs;
              };
            }
            (import ./hosts/grancel)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ];
        };
        ruan = {
          channelName = "nixpkgs";
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/ruan.nix;
                inherit extraSpecialArgs;
              };
            }
            (import ./hosts/ruan)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ];
        };
        crossbell = {
          channelName = "nixpkgs";
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/common.nix;
                inherit extraSpecialArgs;
              };
            }
            (import ./hosts/crossbell)
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        };
        jurai = {
          channelName = "nixpkgs";
          system = "aarch64-darwin";
          output = "darwinConfigurations";

          builder = args:
            darwin.lib.darwinSystem (args
              // {
                modules = [
                  (import ./hosts/jurai)
                  ./modules/core.nix
                  {
                    imports = [home-manager.darwinModule];
                    users.users.price.home = "/Users/price";
                    home-manager = {
                      users.price = ./home-manager/macbook.nix;
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      inherit extraSpecialArgs;
                    };
                  }
                ];
              });
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
