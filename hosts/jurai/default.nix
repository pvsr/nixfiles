{ inputs, ... }:
{
  local.hosts.jurai = { };

  flake.modules.nixos.jurai =
    { lib, pkgs, ... }:
    let
      onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    in
    {
      imports = with inputs.self.modules.nixos; [
        desktop
        kde
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      virtualisation.rosetta.enable = onMacos;

      services.spice-vdagentd.enable = true;
      networking.firewall.enable = false;

      services.openssh.listenAddresses = [ { addr = "0.0.0.0"; } ];

      system.stateVersion = "24.11";
    };
}
