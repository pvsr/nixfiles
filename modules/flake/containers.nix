{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosConfigurations = lib.mapAttrs' (
    name: host:
    lib.nameValuePair "${name}-container" (
      lib.nixosSystem {
        modules = host.modules ++ [
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
      }
    )
  ) config.local.hosts;
}
