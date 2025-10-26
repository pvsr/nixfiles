{ inputs, ... }:
let
  hosts = inputs.self.nixosConfigurations;
  internal = "code.${hosts.ruan.config.networking.fqdn}";
  external = "knot.pvsr.dev";
in
{
  local.servers.crossbell =
    { pkgs, ... }:
    {
      local.caddy.reverseProxies.${external} = "${internal}:5555";
      networking.firewall.allowedTCPPorts = [ 22 ];
      systemd.services.knot-ssh = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:22,fork,reuseaddr TCP6:${internal}:22";
          Restart = "always";
        };
      };
    };

  local.containers."code.ruan" =
    { pkgs, ... }:
    {
      imports = [ inputs.tangled.nixosModules.knot ];
      environment.systemPackages = [
        inputs.tangled.packages.${pkgs.hostPlatform.system}.knot
      ];

      networking.firewall.allowedTCPPorts = [ 5555 ];

      services.tangled.knot = {
        enable = true;
        server = {
          owner = "did:plc:l7ruokyumokt2tduqqvu33j6";
          hostname = external;
        };
      };
    };
}
