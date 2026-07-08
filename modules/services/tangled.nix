{ inputs, ... }:
let
  hosts = inputs.self.nixosConfigurations;
  internal = hosts.grancel.config.microvm.vms.tangled-knot.config.config.networking.fqdn;
  external = "knot.pvsr.dev";
in
{
  local.servers.crossbell =
    { pkgs, ... }:
    {
      local.caddy.reverseProxies.${external} = "${internal}:5555";
      services.openssh.openFirewall = true;
      systemd.services.knot-ssh = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:22,fork,reuseaddr TCP6:${internal}:22";
          Restart = "always";
        };
      };
    };

  local.desktops.grancel.vms.tangled-knot =
    { pkgs, ... }:
    {
      imports = [ inputs.tangled.nixosModules.knot ];
      environment.systemPackages = [
        inputs.tangled.packages.${pkgs.stdenv.hostPlatform.system}.knot
      ];

      microvm.shares = [
        {
          source = "/var/lib/microvms/tangled/git";
          mountPoint = "/home/git";
          tag = "tangled-git-user";
          proto = "virtiofs";
        }
      ];

      services.openssh.openFirewall = true;
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
