{ inputs, ... }:
{
  local.hosts.jurai = {
    system = "aarch64-linux";
  };

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

      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";

      services.spice-vdagentd.enable = true;
      networking.firewall.enable = false;

      services.openssh.listenAddresses = [ { addr = "0.0.0.0"; } ];

      system.stateVersion = "24.11";
    };
}
