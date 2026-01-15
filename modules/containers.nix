{ inputs, lib, ... }:
{
  flake.modules.nixos.container =
    { pkgs, modulesPath, ... }:
    {
      imports = [
        inputs.self.modules.nixos.user
        "${modulesPath}/profiles/minimal.nix"
        "${modulesPath}/virtualisation/lxc-container.nix"
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";

      users.defaultUserShell = pkgs.fishMinimal;
      security.sudo.wheelNeedsPassword = false;

      networking.firewall.enable = true;
      networking.nftables.enable = true;
    };

  flake.modules.nixos.host-container =
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
