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
    foot.terminfo
  ];

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  users.defaultUserShell = pkgs.fish;

  programs.ssh.startAgent = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  systemd.network.wait-online.ignoredInterfaces = ["tailscale0"];
  networking.firewall.trustedInterfaces = ["tailscale0"];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  systemd.oomd.enableRootSlice = true;
  systemd.oomd.enableUserSlices = true;
}
