{ inputs, ... }:
{
  flake.modules.nixos.crossbell =
    { config, pkgs, ... }:
    {
      local.containers.tangled.bindMounts."/home/git/repos" = {
        hostPath = "/home/${config.local.user.name}/src";
        isReadOnly = false;
      };

      local.containers.tangled.config = {
        imports = [ inputs.tangled.nixosModules.knot ];
        environment = {
          # TODO dynamic system
          systemPackages = [ inputs.tangled.packages.x86_64-linux.knot ];
          # sessionVariables.FORGEJO_WORK_DIR = "/var/lib/forgejo";
        };

        services.tangled.knot = {
          enable = true;
          openFirewall = false;
          repo.scanPath = "/home/git/repos";
          server = {
            owner = "did:plc:l7ruokyumokt2tduqqvu33j6";
            hostname = "knot.pvsr.dev";
          };
        };

        services.openssh.settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "git" ];
        };
        services.openssh.listenAddresses = [
          {
            addr = "0.0.0.0";
            # port = 22332;
          }
        ];
      };
    };
}
