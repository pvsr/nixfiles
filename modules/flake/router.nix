{ lib, config, ... }:
let
  cfg = config.router;
in
{
  config.flake.modules.nixos.core.networking = {
    domain = lib.mkDefault cfg.domain;
    search = [ cfg.domain ];
  };

  options.router = {
    domain = lib.mkOption {
      default = "ygg.pvsr.dev";
      readOnly = true;
    };
    ip = lib.mkOption {
      type = lib.types.str;
    };
    hosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
    servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config.flake.modules.hjem.core.ssh.config = ''
    Host router router.${cfg.domain}
      User root
  '';

  config.perSystem =
    { pkgs, ... }:
    let
      dnsmasqHosts =
        cfg.hosts
        |> lib.mapAttrsToList (name: address: "${address} ${name}.${cfg.domain}\n")
        |> lib.concatStrings
        |> pkgs.writeText "dnsmasq.hosts";
      dnsmasqServers =
        cfg.servers
        |> lib.concatMapStrings (server: "server=${server}\n")
        |> pkgs.writeText "dnsmasq.servers";
    in
    {
      packages = {
        inherit dnsmasqHosts dnsmasqServers;
        deploy-router = pkgs.writers.writeFishBin "deploy-router" ''
          set hosts ${dnsmasqHosts}
          set servers ${dnsmasqServers}
          for file in $hosts $servers
            echo (set_color --bold)$file(set_color normal)
            cat $file
            echo
          end
          for var in hosts servers
            set dest /etc/dnsmasq.$var
            echo Deploying $dest
            ${pkgs.openssh}/bin/ssh router "cat > $dest" < $$var
          end
        '';
      };
    };
}
