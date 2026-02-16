{ self, lib, ... }:
let
  hosts = lib.filterAttrs (_: host: !host.config.boot.isContainer) self.nixosConfigurations;
in
{
  flake.modules.nixos.core =
    { config, pkgs, ... }:
    let
      cfg = config.local;
    in
    {
      options.local.endpoints = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            let
              # from https://wiki.nixos.org/wiki/Yggdrasil#Virtual-hosts
              digest = builtins.hashString "sha256" name;
              hextets = builtins.genList (i: builtins.substring (4 * i) 4 digest) 4;
              minPort = 18000;
              maxPort = 18999;
              inherit (builtins.fromTOML "rand = 0x${builtins.substring 0 8 digest}") rand;
            in
            {
              options = {
                public = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                address = lib.mkOption {
                  type = lib.types.str;
                  default = builtins.concatStringsSep ":" ([ cfg.prefix ] ++ hextets);
                };
                port = lib.mkOption {
                  type = lib.types.port;
                  default = minPort + lib.mod rand (maxPort - minPort);
                };
              };
            }
          )
        );
        default = { };
      };

      config = lib.mkIf (cfg.endpoints != { }) {
        networking.firewall.interfaces.${cfg.ethernetInterface}.allowedTCPPorts =
          cfg.endpoints |> builtins.attrValues |> map (builtins.getAttr "port");

        networking.interfaces.${cfg.ethernetInterface}.ipv6.addresses =
          cfg.endpoints
          |> builtins.attrValues
          |> map (
            { address, ... }:
            {
              inherit address;
              prefixLength = 64;
            }
          );

        local.testScript = ''
          interface = machine.succeed(
            "networkctl status --json short | " \
            "${pkgs.jq}/bin/jq -r '.Interfaces[].Name' | " \
            "grep -E '^e(n|th)' | head -1"
          ).strip()
          endpoints = ${cfg.endpoints |> builtins.attrValues |> builtins.length |> toString}
          machine.wait_until_succeeds(
            f"networkctl status {interface} --json short | " \
            f"${pkgs.jq}/bin/jq '.Addresses | length' | grep {endpoints + 1}",
            timeout=30
          )
        '';
      };
    };

  flake.modules.nixos.yggdrasilNameServer.networking.hosts = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.mapAttrs' (
      name: vhost: lib.nameValuePair vhost.address [ "${name}.${host.config.networking.fqdn}" ]
    )
  ) hosts;

  local.servers.crossbell.local.caddy.reverseProxies = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.filterAttrs (_: vhost: vhost.public != null)
    |> lib.mapAttrs' (
      name: vhost:
      lib.nameValuePair vhost.public "${name}.${host.config.networking.fqdn}:${toString vhost.port}"
    )
  ) hosts;

}
