{ config, lib, pkgs, ... }:
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
  ];

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
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


  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
