{pkgs, ...}: {
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

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.ssh.startAgent = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
}
