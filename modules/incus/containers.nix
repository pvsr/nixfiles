{ inputs, lib, ... }:
{
  flake.modules.nixos.container =
    { pkgs, modulesPath, ... }:
    {
      imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";

      security.sudo.wheelNeedsPassword = false;

      networking.firewall.allowedTCPPorts = [ 22 ];
      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
    };

  flake.modules.nixos.hostContainer =
    { pkgs, modulesPath, ... }:
    {
      imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];
      disabledModules = [ inputs.srvos.nixosModules.hardware-vultr-vm ];

      nixpkgs.hostPlatform = "x86_64-linux";
      fileSystems = lib.mkForce { };
      local.persistence.enable = lib.mkForce false;
      boot.loader.systemd-boot.enable = lib.mkForce false;

      networking.useHostResolvConf = false;
      networking.firewall.allowedTCPPorts = [ 22 ];

      services.displayManager.ly.enable = lib.mkForce false;
    };
}
