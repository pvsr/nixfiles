{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    hjem.url = "github:feel-co/hjem";
    hjem.inputs.nixpkgs.follows = "nixpkgs";
    hjem.inputs.nix-darwin.follows = "nix-darwin";
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.inputs.home-manager.follows = "";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.url = "github:nix-community/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs";

    qbpm.url = "github:pvsr/qbpm";
    qbpm.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.url = "github:pvsr/podcasts";
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.inputs.pre-commit-hooks.follows = "";
    weather.url = "github:pvsr/weather";
    weather.inputs.nixpkgs.follows = "nixpkgs";
    weather.inputs.pre-commit-hooks.follows = "";

    srcery-textmate.url = "github:srcery-colors/srcery-textmate";
    srcery-textmate.flake = false;

    fzf-fish.url = "github:pvsr/fzf.fish";
    fzf-fish.flake = false;
    fish-prompt-pvsr.url = "github:pvsr/fish-prompt-pvsr";
    fish-prompt-pvsr.flake = false;
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = map import-tree [ ./modules ];
    };
}
