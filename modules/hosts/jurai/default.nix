{ inputs, ... }:
{
  local.hosts.jurai = { };

  flake.modules.hjem.jurai.niri.extraConfig = ''output "winit" { scale 2.0; }'';

  flake.modules.nixos.jurai =
    { lib, pkgs, ... }:
    let
      onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    in
    {
      imports = [
        inputs.self.modules.nixos.desktop
        inputs.self.modules.nixos.kde
      ];
      hjem.extraModules = [ inputs.self.modules.hjem.desktop ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      virtualisation.rosetta.enable = onMacos;

      services.spice-vdagentd.enable = true;
      networking.firewall.enable = false;

      system.stateVersion = "24.11";
    };
}
