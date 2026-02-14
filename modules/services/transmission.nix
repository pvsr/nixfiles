{ self, ... }:
{
  local.desktops.ruan =
    { config, pkgs, ... }:
    {
      age.secrets."transmission-credentials.json" = {
        file = ../hosts/ruan/secrets/transmission-credentials.json.age;
        owner = "transmission";
        group = "transmission";
      };

      local.user.extraGroups = [ "transmission" ];

      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        openPeerPorts = true;
        openRPCPort = true;
        credentialsFile = config.age.secrets."transmission-credentials.json".path;
        settings = {
          peer-port-random-on-start = true;
          peer-port-random-low = 65150;
          peer-port-random-high = 65160;
          rpc-port = 9919;
          rpc-host-whitelist = with config.networking; "${hostName},${fqdn}";
          rpc-bind-address = config.local.ip;
          rpc-whitelist-enabled = false;
        };
      };

      environment.persistence.data.directories = [ "/var/lib/transmission" ];
    };

  flake.modules.hjem.desktop.fish.interactiveShellInit = ''
    abbr -a trr 'transmission-remote ${self.nixosConfigurations.ruan.config.networking.fqdn}:9919'
  '';
}
