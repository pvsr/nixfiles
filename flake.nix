
{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-20.09;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager = {
      url = "/home/peter/dev/home-manager";
      #url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;

  };


  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, home-manager, neovim-nightly-overlay }:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;
      channels.unstable.input = unstable;

      channelsConfig.allowUnfree = true;

      nixosProfiles = {
        ruan = {
          #channelName = "unstable";
          modules = [
            {
              boot.isContainer = true;
              networking.useDHCP = false;
            }
            #(import ./configurations/Morty.host.nix)
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

      # Shared modules/configurations between `nixosProfiles`
      sharedModules = [
        home-manager.nixosModules.home-manager
        # Sets sane `nix.*` defaults. Please refer to implementation/readme for more details.
        utils.nixosModules.saneFlakeDefaults
        #(import ./modules)
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
