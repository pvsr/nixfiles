{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  cfg = config.local;
in
{
  flake.nixosConfigurations = lib.mapAttrs' (
    name: module:
    lib.nixosSystem {
      modules = [
        module
        inputs.microvm.nixosModules.microvm
        inputs.self.modules.nixos.microvm-guest
        {
          disabledModules = [ inputs.srvos.nixosModules.hardware-vultr-vm ];

          microvm.mem = 1536;
          microvm.proto = "9p";

          disko.devices = lib.mkForce { };
          fileSystems."/run/media/persist".enable = false;
          local.persistence.enable = lib.mkForce false;

          services.yggdrasil.enable = lib.mkForce false;
        }
      ];
    }
    |> lib.nameValuePair "${name}-vm"
  ) cfg.hosts;
}
