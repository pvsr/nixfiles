{
  description = "A system configuration.";

  inputs = {
    #nixpkgs.url = github:nixos/nixpkgs/release-20.09;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "unstable";
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
    , unstable
    , nur
    , utils
    , home-manager
    , home-manager-unstable
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
      #channels.unstable.input = unstable;

      channelsConfig.allowUnfree = true;

      hosts = {
        ruan = {
          #channelName = "unstable";
          modules = [
            {
              home-manager = {
                users.peter = import ./home-manager/ruan.nix;
                # kinda hacky
                extraSpecialArgs = { inherit appFont fishPlugins; };
              };
            }
            (import ./hosts/ruan.nix)
          ];
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

      homeConfigurations."peter@grancel" = home-manager-unstable.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/peter";
        username = "peter";
        configuration = { config, pkgs, ... }: {
          imports = [ ./home-manager/grancel.nix ];

          nixpkgs.overlays = sharedOverlays;
        };
        extraSpecialArgs = { inherit appFont fishPlugins; };
      };

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
        transmission
        wireguard
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
        ./modules/transmission.nix
        ./modules/wireguard.nix

        ./users/peter.nix
      ];
    };
}
