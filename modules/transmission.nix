{
  local.desktops.ruan =
    { config, pkgs, ... }:
    {
      age.secrets."transmission-credentials.json" = {
        file = ../modules/hosts/ruan/secrets/transmission-credentials.json.age;
        owner = "transmission";
        group = "transmission";
      };

      local.user.extraGroups = [ "transmission" ];

      services.transmission = {
        enable = true;
        package = pkgs.transmission_4.overrideAttrs {
          version = "4.0.5";
          src = pkgs.fetchFromGitHub {
            owner = "transmission";
            repo = "transmission";
            rev = "4.0.5";
            hash = "sha256-gd1LGAhMuSyC/19wxkoE2mqVozjGPfupIPGojKY0Hn4=";
            fetchSubmodules = true;
          };
        };
        openPeerPorts = true;
        openRPCPort = true;
        credentialsFile = config.age.secrets."transmission-credentials.json".path;
        settings = {
          peer-port-random-on-start = true;
          peer-port-random-low = 65150;
          peer-port-random-high = 65160;
          rpc-port = 9919;
          rpc-host-whitelist = "ruan,ruan.ygg.pvsr.dev";
          rpc-bind-address = config.local.ip;
          rpc-whitelist-enabled = false;
        };
      };

      environment.persistence.data.directories = [ "/var/lib/transmission" ];
    };

  flake.modules.hjem.desktop.fish.interactiveShellInit = ''
    abbr -a trr 'transmission-remote ruan.ygg.pvsr.dev:9919'
  '';
}
