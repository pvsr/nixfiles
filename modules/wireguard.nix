{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ wireguard ];

  networking.firewall.allowedUDPPorts = [ 53114 ];

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.0.0.3/24" ];
    listenPort = 53114;

    privateKeyFile = "/home/peter/.ssh/wireguard/ruan.key";

    peers = [
      {
        publicKey = "fiVDal4zgxwXG7fuiZGOHhhGZkh0nYub9JkR+wqzQSk=";
        allowedIPs = [ "10.0.0.1/32" "fdc9:281f:4d7:9ee9::1/128" ];
        endpoint = "54.39.20.214:53113";
        persistentKeepalive = 25;
      }
      {
        publicKey = "mvYR1JDbe2JhSO/mZ0bV/AxTYZXqsG9GhhkOU8R1/SU=";
        allowedIPs = [ "10.0.0.2/32" "fdc9:281f:4d7:9ee9::2/128" ];
        endpoint = "grancel:53331";
      }
    ];
  };
}
