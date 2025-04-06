{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./machines.nix
    ./tailscale.nix
    ./impermanence.nix
    ../users/peter.nix
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
  ];

  nixpkgs.overlays = [
    (import ../overlay.nix inputs)
  ];

  environment = {
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
      ghostty.terminfo
      (pkgs.writeScriptBin "deploy" (builtins.readFile ./deploy.fish))
    ];
  };

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
}
