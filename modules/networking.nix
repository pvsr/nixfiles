{
  flake.modules.nixos.core = {
    networking.nftables.enable = true;

    networking.nameservers = [ "94.140.14.14" ];

    services.openssh = {
      enable = true;
      openFirewall = false;
      startWhenNeeded = true;
      listenAddresses = [ { addr = "[::]"; } ];
    };
    networking.firewall.interfaces.enp8s0.allowedTCPPorts = [ 22 ];
    networking.firewall.interfaces.enp37s0.allowedTCPPorts = [ 22 ];
  };
}
