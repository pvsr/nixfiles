{
  flake.modules.nixos.ruan =
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
          rpc-host-whitelist = "ruan,ruan.ts.peterrice.xyz";
          rpc-bind-address = config.local.tailscale.ip;
          rpc-whitelist-enabled = false;
        };
      };
    };

  flake.modules.homeManager.desktop.programs.fish.shellAbbrs.trr =
    "transmission-remote ruan.ts.peterrice.xyz:9919";
}
