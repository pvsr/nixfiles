{ config, pkgs, lib, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ cachix ];

    nix = {
       extraOptions = "gc-keep-outputs = true";

      binaryCaches = [
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      binaryCachePublicKeys = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };
  };
}
