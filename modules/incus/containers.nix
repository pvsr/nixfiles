{ inputs, lib, ... }:
let
  lxcKey = ./.;
in
{
  flake.modules.nixos.lxc =
    { pkgs, modulesPath, ... }:
    {
      key = lxcKey;

      imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];

      nixpkgs.hostPlatform = "x86_64-linux";

      networking.useHostResolvConf = false;
      networking.firewall.allowedTCPPorts = [ 22 ];
    };

  flake.modules.nixos.test.disabledModules = [ lxcKey ];

  flake.modules.nixos.container = {
    imports = [ inputs.self.modules.nixos.lxc ];

    system.stateVersion = "26.05";

    security.sudo.wheelNeedsPassword = false;
    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  };

  flake.modules.nixos.hostContainer = {
    imports = [ inputs.self.modules.nixos.lxc ];

    disabledModules = [ inputs.srvos.nixosModules.hardware-vultr-vm ];

    hardware.facter.report = { };
    fileSystems = lib.mkForce { };
    local.persistence.enable = lib.mkForce false;
    boot.loader.systemd-boot.enable = lib.mkForce false;
    services.displayManager.ly.enable = lib.mkForce false;
  };
}
