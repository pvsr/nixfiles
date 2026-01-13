{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  modules = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      disabledModules = [ inputs.srvos.nixosModules.hardware-vultr-vm ];

      fileSystems = lib.mkForce { };
      networking.useHostResolvConf = false;
      networking.firewall.allowedTCPPorts = [ 22 ];
      boot.loader.systemd-boot.enable = lib.mkForce false;
      services.displayManager.ly.enable = lib.mkForce false;
    }
  ];
in
{
  options.local.containers = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
  };

  config.flake.nixosConfigurations =
    (lib.mapAttrs' (
      name: host:
      lib.nameValuePair "${name}.incus" (
        lib.nixosSystem {
          modules = host.modules ++ modules;
        }
      )
    ) config.local.hosts)
    // (builtins.mapAttrs (
      name: module:
      lib.nixosSystem {
        modules = [ module ] ++ modules;
      }
    ) config.local.containers);
}
