{
  lib,
  inputs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };
    registry = builtins.mapAttrs (_: flake: {inherit flake;}) inputs;
  };

  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/inputs/${name}";
      value.source = value.outPath;
    })
    inputs;
}
