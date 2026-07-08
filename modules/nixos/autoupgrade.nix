{
  flake.modules.nixos.core.system.autoUpgrade = {
    enable = true;
    flake = "git+https://forgejo.grancel.ygg.pvsr.dev/peter/nixos";
    dates = "06:00";
    persistent = false;
  };
}
