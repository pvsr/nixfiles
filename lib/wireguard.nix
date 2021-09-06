{
  crossbell = {
    allowedIPs = [ "10.0.0.1/32" "fdc9:281f:4d7:9ee9::1/128" ];
    listenPort = 53113;
    publicKey = "fiVDal4zgxwXG7fuiZGOHhhGZkh0nYub9JkR+wqzQSk=";
    endpoint = "54.39.20.214:53113";
    persistentKeepalive = 25;
  };
  grancel = {
    allowedIPs = [ "10.0.0.2/32" "fdc9:281f:4d7:9ee9::2/128" ];
    listenPort = 53331;
    publicKey = "LNCNTfeJNHreKYvAvn3kdI3h2TIaMuQAnQYPV5evm1U=";
    endpointFrom = {
      ruan = "grancel:53331";
    };
  };
  ruan = {
    allowedIPs = [ "10.0.0.3/32" "fdc9:281f:4d7:9ee9::3/128" ];
    listenPort = 53114;
    publicKey = "s796jSbUDMSD9T7ARvXXoVKoBuh3/5qw2p7AXvdSjxw=";
    endpointFrom = {
      grancel = "ruan:53114";
    };
  };
}
