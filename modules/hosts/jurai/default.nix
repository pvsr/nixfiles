{ inputs, lib, ... }:
{
  flake.modules.hjem.jurai.niri.extraConfig = ''output "winit" { scale 2.0; }'';

  local.desktops.jurai =
    { pkgs, modulesPath, ... }:
    let
      onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    in
    {
      imports = [
        "${modulesPath}/profiles/qemu-guest.nix"
        inputs.self.modules.nixos.kde
      ];
      hjem.extraModules = [ inputs.self.modules.hjem.desktop ];

      hardware.facter.reportPath = ./facter.json;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      virtualisation.rosetta.enable = onMacos;
      fileSystems."/run/media/host" = lib.mkIf onMacos {
        device = "share";
        fsType = "virtiofs";
      };

      services.spice-vdagentd.enable = true;
      networking.firewall.enable = false;

      system.stateVersion = "24.11";
    };
}
