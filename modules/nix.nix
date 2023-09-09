{
  flake,
  lib,
  ...
}: let
  inputs = with flake.inputs; {
    inherit self nixpkgs unstable home-manager;
  };
in {
  nix = {
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry = builtins.mapAttrs (_: value: {flake = value;}) inputs;
  };

  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/inputs/${name}";
      value.source = value.outPath;
    })
    inputs;
}
