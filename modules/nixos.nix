{ inputs, ... }:
{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        "${modulesPath}/profiles/minimal.nix"
        inputs.agenix.nixosModules.age
        inputs.disko.nixosModules.disko
      ];

      environment.systemPackages = with pkgs; [
        binutils
        coreutils
        curl
        dnsutils
        dosfstools
        file
        iputils
        lsof
        psmisc
        rsync
        util-linux
        ghostty.terminfo
      ];

      time.timeZone = lib.mkDefault "America/New_York";

      security.sudo.wheelNeedsPassword = false;

      programs.ssh.startAgent = true;

      services.fstrim.enable = true;

      systemd.oomd.enableRootSlice = true;
      systemd.oomd.enableUserSlices = true;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };

      # override srvos, needed by btrbk only
      security.sudo.execWheelOnly = lib.mkForce false;

      services.dbus.implementation = "broker";
    };
}
