{ inputs, config, ... }:
let
  hosts = config.flake.nixosConfigurations;
in
{
  flake.modules.nixos.machine =
    { config, lib, ... }:
    {
      disabledModules = [
        inputs.srvos.nixosModules.hardware-vultr-vm
        inputs.nixos-hardware.nixosModules.common-gpu-amd
      ];
      networking.useHostResolvConf = false;
      services.tailscale.enable = false;
      # TODO get agenix working in containers for real?
      age.identityPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

  flake.modules.nixos.machines =
    { config, lib, ... }:
    let
      options.local.machines = {
        autoStart = lib.mkOption { default = true; };
        only = lib.mkOption { default = builtins.attrNames hosts; };
      };
      cfg = config.local.machines;
      enabledHosts = lib.filterAttrs (hostname: host: lib.elem hostname cfg.only) hosts;
      key = "local.machines";
      mkContainer = hostname: host: {
        inherit (cfg) autoStart;
        privateNetwork = true;
        hostAddress = "192.168.100.100";
        localAddress = "192.168.100.${toString host.config.local.id}";
        hostAddress6 = "fc00::100";
        localAddress6 = "fc00::${toString host.config.local.id}";
        config.imports = [
          inputs.self.modules.nixos.machine
          inputs.self.modules.nixos.${hostname}
          { inherit options; }
          {
            disabledModules = [ { inherit key; } ];
            networking.hostName = lib.mkForce "${hostname}-c";
          }
        ];
      };
    in
    {
      inherit key options;

      config = lib.mkIf (enabledHosts != { }) {
        containers = builtins.mapAttrs mkContainer enabledHosts;
      };
    };
}
