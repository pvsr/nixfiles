{
  flake.modules.nixos.core = {
    networking.nftables.enable = true;

    networking.nameservers = [ "185.71.138.138" ];

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
