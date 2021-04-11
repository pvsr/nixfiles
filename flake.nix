
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
  };


  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, home-manager, neovim-nightly-overlay, agenix }:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;
      #channels.unstable.input = unstable;

      channelsConfig.allowUnfree = true;

      nixosProfiles = {
        ruan = {
          channelName = "unstable";
          modules = [
            {
              home-manager.users.peter = import ./home-manager/ruan.nix;
            }
            (import ./hosts/ruan.nix)
          ];
        };
      };

      sharedExtraArgs = { inherit utils inputs; };

      # Shared overlays between channels, gets applied to all `channels.<name>.input`
      sharedOverlays = [
        #self.overlays
        nur.overlay
        neovim-nightly-overlay.overlay
      ];

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
