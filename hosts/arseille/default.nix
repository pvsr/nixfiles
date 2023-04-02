{pkgs, ...}: {
  system.stateVersion = "22.11";
  time.timeZone = "America/New_York";
  user.shell = "${pkgs.fish}/bin/fish";

  environment.packages = with pkgs; [
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

    openssh
    which
    gnused
    gawk
    rsync
  ];
}
