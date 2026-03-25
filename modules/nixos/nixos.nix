{
  flake.modules.nixos.base = {
    time.timeZone = "America/New_York";
  };

  flake.modules.nixos.core =
    { lib, pkgs, ... }:
    {
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
      ];

      security.sudo.wheelNeedsPassword = false;

      programs.ssh.startAgent = true;

      services.fstrim.enable = true;

      systemd.oomd.enableRootSlice = true;
      systemd.oomd.enableUserSlices = true;

      boot.kernelParams = [
        "zswap.enabled=1"
        "zswap.compressor=lz4"
        "zswap.max_pool_percent=20"
        "zswap.shrinker_enabled=1"
      ];

      # override srvos, needed by btrbk only
      security.sudo.execWheelOnly = lib.mkForce false;

      services.dbus.implementation = "broker";
    };
}
