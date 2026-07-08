{ inputs, lib, ... }:
{
  flake.modules.nixos.base = {
    nix.registry = builtins.mapAttrs (_: flake: { flake = lib.mkDefault flake; }) (
      lib.filterAttrs (name: _: name != "nixpkgs") inputs
    );

    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/inputs/${name}";
      value.source = value.outPath;
    }) inputs;

    nix = {
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
}
