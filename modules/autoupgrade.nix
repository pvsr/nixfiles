{
  flake.modules.nixos.core.system.autoUpgrade = {
    enable = true;
    flake = "git+https://code.pvsr.dev/peter/nixos";
    dates = "06:00";
    persistent = false;
  };
}
