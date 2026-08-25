{ inputs, lib, ... }:
let
  registry = builtins.mapAttrs (_: flake: { flake = lib.mkDefault flake; }) inputs;
in
{
  flake.modules.nixos.base = {
    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/inputs/${name}";
      value.source = value.outPath;
    }) inputs;

    nix = {
      inherit registry;
      settings = {
        auto-optimise-store = true;
        sandbox = true;
        allowed-users = [ "@wheel" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        use-xdg-base-directories = true;
        experimental-features = [ "pipe-operator" ];
      };
    };
  };

  flake.modules.nixOnDroid.base = {
    nix = {
      inherit registry;
      extraOptions = ''
        experimental-features = nix-command flakes pipe-operators
      '';
    };
  };
}
