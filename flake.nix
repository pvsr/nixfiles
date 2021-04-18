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

    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = github:serokell/deploy-rs;

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    nvim-colorizer.url = github:norcalli/nvim-colorizer.lua;
    nvim-colorizer.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
    z.url = github:jethrokuan/z;
    z.flake = false;
    fzf.url = github:jethrokuan/fzf;
    fzf.flake = false;
    plugin-git.url = github:jhillyerd/plugin-git;
    plugin-git.flake = false;
  };


  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, home-manager, neovim-nightly-overlay, agenix, deploy-rs, ... }:
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
          fishPlugins = prev.fishPlugins // {
            fish-prompt-pvsr = prev.fishPlugins.buildFishPlugin {
              pname = "fish-prompt-pvsr";
              version = "git";
              src = inputs.fish-prompt-pvsr;
              preInstall = ''
                mv -f *.fish functions/
              '';
            };
            z = prev.fishPlugins.buildFishPlugin {
              pname = "z";
              version = "git";
              src = inputs.z;
            };
            fzf = prev.fishPlugins.buildFishPlugin {
              pname = "fzf";
              version = "git";
              src = inputs.fzf;
            };
            plugin-git = prev.fishPlugins.buildFishPlugin {
              pname = "plugin-git";
              version = "git";
              src = inputs.plugin-git;
            };
          };
        });
      sharedOverlays = [
        pluginOverlay
        nur.overlay
        neovim-nightly-overlay.overlay
        (final: prev: {
          deploy-rs = deploy-rs.packages.${prev.system}.deploy-rs;
          agenix = agenix.packages.${prev.system}.agenix;
        })
      ];
    in
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;
      #channels.unstable.input = unstable;

      channelsConfig.allowUnfree = true;

      nixosProfiles = {
        ruan = {
          #channelName = "unstable";
          modules = [
            {
              home-manager.users.peter = import ./home-manager/ruan.nix;
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

      homeConfigurations."peter@grancel" = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/peter";
        username = "peter";
        configuration = { config, pkgs, ... }: {
          imports = [ ./home-manager/grancel.nix ];

          nixpkgs.overlays = sharedOverlays;
        };
        # extraSpecialArgs.fishPlugins = {
        #   inherit (inputs) fish-prompt-pvsr z fzf plugin-git;
        # };
      };

      sharedExtraArgs = { inherit utils inputs; };

      inherit sharedOverlays;

      sharedModules = with self.nixosModules; [
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
