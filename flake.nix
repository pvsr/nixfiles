{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-21.05;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager.url = github:nix-community/home-manager/release-21.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = github:ryantm/agenix;
    deploy-rs.url = github:serokell/deploy-rs;
    qbpm.url = github:pvsr/qbpm;
    qbpm.inputs.nixpkgs.follows = "nixpkgs";

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    nvim-colorizer.url = github:norcalli/nvim-colorizer.lua;
    nvim-colorizer.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
    fish-z.url = github:jethrokuan/z;
    fish-z.flake = false;
    fzf-fish.url = github:PatrickF1/fzf.fish;
    fzf-fish.flake = false;
    fish-plugin-git.url = github:jhillyerd/plugin-git;
    fish-plugin-git.flake = false;
  };


  outputs =
    inputs@{ self
    , nixpkgs
    , unstable
    , nixos-hardware
    , utils
    , home-manager
    , agenix
    , deploy-rs
    , ...
    }:
    let
      pluginOverlay =
        (final: prev: {
          tmuxPlugins = prev.tmuxPlugins // {
            srcery = prev.tmuxPlugins.mkTmuxPlugin {
              pluginName = "srcery";
              version = "git";
              src = inputs.srcery-tmux;
            };
          };
          vimPlugins = prev.vimPlugins // {
            nvim-colorizer = prev.vimUtils.buildVimPluginFrom2Nix {
              pname = "nvim-colorizer";
              version = "git";
              src = inputs.nvim-colorizer;
            };
          };
        });
      sharedOverlays = [
        pluginOverlay
        (final: prev: {
          qbpm = inputs.qbpm.packages.${prev.system}.qbpm;
        })
      ];
      fishPlugins = with inputs; {
        inherit fish-prompt-pvsr;
        z = fish-z;
        fzf = fzf-fish;
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

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          inherit (channels.unstable) neovim neovim-unwrapped;
        })
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        {
          nix.generateNixPathFromInputs = true;
          nix.generateRegistryFromInputs = true;
          nix.linkInputs = true;
        }

        ./modules/core.nix
        ./modules/cachix.nix
        ./modules/dev.nix
        ./modules/graphical.nix
        ./modules/steam.nix

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
            (import ./hosts/grancel.nix)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ];
        };
        ruan = {
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/ruan.nix;
                inherit extraSpecialArgs;
              };
            }
            (import ./hosts/ruan.nix)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
            ./modules/wireguard.nix
            ./modules/transmission.nix
          ];
        };
        peter = {
          output = "homeConfigurations";

          builder = args: home-manager.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/peter";
            username = "peter";
            configuration = { config, pkgs, ... }: {
              imports = [ ./home-manager/arch.nix ];
              nixpkgs.overlays = sharedOverlays;
            };
            inherit extraSpecialArgs;
          };
        };
        price = {
          output = "homeConfigurations";

          builder = args: home-manager.lib.homeManagerConfiguration {
            system = "x86_64-darwin";
            homeDirectory = "/Users/price";
            username = "price";
            configuration = { config, pkgs, ... }: {
              imports = [ ./home-manager/macbook.nix ];
              nixpkgs.overlays = sharedOverlays;
            };
            inherit extraSpecialArgs;
          };
        };
      };

      deploy.nodes.ruan = {
        hostname = "ruan";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ruan;
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      outputsBuilder = channels: {
        devShell = channels.nixpkgs.mkShell {
          buildInputs = [
            deploy-rs.packages.${channels.nixpkgs.system}.deploy-rs
            agenix.packages.${channels.nixpkgs.system}.agenix
          ];
        };
      };
    };
}
