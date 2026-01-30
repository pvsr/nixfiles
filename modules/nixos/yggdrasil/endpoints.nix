{ self, lib, ... }:
let
  hosts = lib.filterAttrs (_: host: !host.config.boot.isContainer) self.nixosConfigurations;
in
{
  flake.modules.nixos.core =
    { config, ... }:
    let
      inherit (config.local) prefix endpoints;
      # from https://wiki.nixos.org/wiki/Yggdrasil#Virtual-hosts
      toIpv6Address =
        seed:
        let
          digest = builtins.hashString "sha256" seed;
          hextets = builtins.genList (i: builtins.substring (4 * i) 4 digest) 4;
        in
        builtins.concatStringsSep ":" ([ prefix ] ++ hextets);
    in
    {
      options.local.endpoints = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                public = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                address = lib.mkOption {
                  type = lib.types.str;
                  default = toIpv6Address name;
                };
              };
            }
          )
        );
        default = { };
      };

      config.environment.etc."systemd/network/40-${config.local.ethernetInterface}.network.d/extra-yggdrasil-ips.conf" =
        lib.mkIf (endpoints != { }) {
          text =
            "[Network]\n"
            + lib.concatMapStringsSep "\n" (endpoint: "Address=${endpoint.address}/64") (
              lib.attrValues endpoints
            );
        };
    };

  flake.modules.nixos.yggdrasilNameServer.networking.hosts = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.mapAttrs' (
      name: vhost: lib.nameValuePair vhost.address [ "${name}.${host.config.networking.fqdn}" ]
    )
  ) hosts;

  local.hosts.crossbell.local.caddy.reverseProxies = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.filterAttrs (_: vhost: vhost.public != null)
    |> lib.mapAttrs' (
      name: vhost: lib.nameValuePair vhost.public "${name}.${host.config.networking.fqdn}:2808"
    )
  ) hosts;

}
