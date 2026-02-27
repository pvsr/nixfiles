{ inputs, ... }:
{
  flake.modules.nixos.server = {
    imports = [ inputs.srvos.nixosModules.server ];

    hardware.facter.detected.graphics.enable = false;

    # override srvos
    programs.vim = {
      enable = false;
      defaultEditor = false;
    };
  };
}
