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

      config.systemd.network.networks."40-extra-yggdrasil-ips" = {
        matchConfig.Name = "enp*";
        DHCP = "yes";
        networkConfig.IPv6PrivacyExtensions = "kernel";
        address = lib.mapAttrsToList (name: { address, ... }: "${address}/64") endpoints;
      };
    };

  flake.modules.nixos.yggdrasilNameServer.networking.hosts = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.mapAttrs' (
      name: vhost: lib.nameValuePair vhost.address [ "${name}.${hostname}.ygg.pvsr.dev" ]
    )
  ) hosts;

  local.hosts.crossbell.local.caddy.reverseProxies = lib.concatMapAttrs (
    hostname: host:
    host.config.local.endpoints
    |> lib.filterAttrs (_: vhost: vhost.public != null)
    |> lib.mapAttrs' (
      name: vhost: lib.nameValuePair vhost.public "${name}.${hostname}.ygg.pvsr.dev:2808"
    )
  ) hosts;

}
