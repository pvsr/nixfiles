{ pkgs, inputs, ... }:
{
  imports = [
    ./nix.nix
    ./nixos.nix
    ./machines.nix
    ./containers.nix
    ./tailscale.nix
    ./impermanence.nix
    ../users/peter.nix
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];

  nixpkgs.overlays = [ (import ../overlay.nix inputs) ];

  environment.systemPackages = [ (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish)) ];
}
