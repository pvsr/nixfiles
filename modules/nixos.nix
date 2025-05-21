{
  pkgs,
  lib,
  ...
}:
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
    utillinux
    ghostty.terminfo
  ];

  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  users.defaultUserShell = pkgs.fish;

  programs.ssh.startAgent = true;

  networking.nftables.enable = true;

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

  virtualisation =
    let
      variant = {
        nixpkgs.hostPlatform = "x86_64-linux";
        disabledModules = [ ./tailscale.nix ];
        users.users.peter.password = "";
        virtualisation = {
          cores = 3;
          memorySize = 1024 * 3;
          graphics = false;
        };
      };
    in
    {
      vmVariant = variant;
      vmVariantWithDisko = variant;
    };

  services.prometheus.exporters.node = {
    enable = lib.mkDefault true;
    port = 54247;
    enabledCollectors = [ "systemd" ];
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 54247 ];
}
