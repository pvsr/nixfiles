{ pkgs, lib, ... }:
{
  environment = {
    sessionVariables = {
      PAGER = "${pkgs.moar}/bin/moar";
      MOAR = builtins.concatStringsSep " " [
        "-quit-if-one-screen"
        "-statusbar=bold"
        "-no-statusbar"
        "-no-linenumbers"
        "-no-clear-on-exit"
      ];
    };
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      dnsutils
      dosfstools
      file
      iputils
      lsof
      psmisc
      utillinux
      foot.terminfo
    ];
  };

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  users.defaultUserShell = pkgs.fish;

  programs.ssh.startAgent = true;

  networking.nftables.enable = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  systemd.network.wait-online.ignoredInterfaces = [ "tailscale0" ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

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
}
