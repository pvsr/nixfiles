{ config, lib, pkgs, ... }:
{
  #nix.package = pkgs.nixFlakes;

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      dnsutils
      dosfstools
      fd
      git
      gptfdisk
      htop
      iputils
      #manix
      moreutils
      ncdu
      nix-index
      nmap
      ranger
      ripgrep
      utillinux
      whois
    ];
  };

  fonts = {
    fonts = with pkgs; [ dejavu_fonts ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  services.earlyoom.enable = true;

  #users.mutableUsers = false;
}
