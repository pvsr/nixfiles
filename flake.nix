{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-21.05;
    nixos-hardware.url = github:nixos/nixos-hardware;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
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
    , nixos-hardware
    , nur
    , utils
    , home-manager
    , neovim-nightly-overlay
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
      fishPlugins = with inputs; {
        inherit fish-prompt-pvsr;
        z = fish-z;
        fzf = fzf-fish;
        plugin-git = fish-plugin-git;
      };
      sharedOverlays = [
        pluginOverlay
        nur.overlay
        neovim-nightly-overlay.overlay
        (final: prev: {
          deploy-rs = deploy-rs.packages.${prev.system}.deploy-rs;
          agenix = agenix.packages.${prev.system}.agenix;
          qbpm = inputs.qbpm.packages.${prev.system}.qbpm;
        })
      ];
      appFont = "Fantasque Sans Mono";
    in
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;

      channelsConfig.allowUnfree = true;

      hosts = {
        grancel = {
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/grancel.nix;
                extraSpecialArgs = { inherit appFont fishPlugins; };
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
                extraSpecialArgs = { inherit appFont fishPlugins; };
              };
            }
            (import ./hosts/ruan.nix)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
          ] ++
          (with self.nixosModules; [
            wireguard
            transmission
          ]);
        };
        "peter" = {
          output = "homeConfigurations";

          builder = args: home-manager.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/peter";
            username = "peter";
            configuration = { config, pkgs, ... }: {
              imports = [ ./home-manager/arch.nix ];
              nixpkgs.overlays = sharedOverlays;
            };
            extraSpecialArgs = { inherit appFont fishPlugins; };
          };
        };
        "price" = {
          output = "homeConfigurations";

          builder = args: home-manager.lib.homeManagerConfiguration {
            system = "x86_64-darwin";
            homeDirectory = "/Users/price";
            username = "price";
            configuration = { config, pkgs, ... }: {
              imports = [ ./home-manager/macbook.nix ];
              nixpkgs.overlays = sharedOverlays;
            };
            extraSpecialArgs = { inherit appFont fishPlugins; };
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

      hostDefaults.extraArgs = { inherit utils inputs; };

      inherit sharedOverlays;

      hostDefaults.modules = with self.nixosModules; [
        home-manager.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        agenix.nixosModules.age
        core
        cachix
        dev
        graphical
        steam
        peter
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      nixosModules = utils.lib.modulesFromList [
        ./modules/core.nix

        ./modules/cachix.nix
        ./modules/dev.nix
        ./modules/graphical.nix
        ./modules/steam.nix
        ./modules/transmission.nix
        ./modules/wireguard.nix

        ./users/peter.nix
      ];
    };
}
