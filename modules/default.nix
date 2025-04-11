{ pkgs, inputs, ... }:
{
  imports = [
    ./nix.nix
    ./nixos.nix
    ./user.nix
    ./hosts.nix
    ./machines.nix
    ./containers.nix
    ./caddy.nix
    ./tailscale.nix
    ./impermanence.nix
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];

  environment.systemPackages = [ (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish)) ];
}
