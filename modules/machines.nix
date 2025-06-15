{
  config,
  lib,
  inputs,
  hosts,
  specialArgs,
  ...
}:
let
  options.local.machines = {
    enable = lib.mkEnableOption { };
    autoStart = lib.mkOption { default = true; };
    only = lib.mkOption { default = builtins.attrNames hosts; };
  };
  cfg = config.local.machines;
  enabledHosts = lib.filterAttrs (hostname: host: lib.elem hostname cfg.only) hosts;
  mkContainer = hostname: host: {
    inherit specialArgs;
    autoStart = host.autoStart or cfg.autoStart;
    privateNetwork = true;
    hostAddress = "192.168.100.100";
    localAddress = "192.168.100.${toString host.nixos.config.local.id}";
    hostAddress6 = "fc00::100";
    localAddress6 = "fc00::${toString host.nixos.config.local.id}";
    config.imports = host.modules ++ [
      { inherit options; }
      {
        disabledModules = [
          ./machines.nix
          inputs.srvos.nixosModules.hardware-vultr-vm
          inputs.nixos-hardware.nixosModules.common-gpu-amd
        ];
        networking.hostName = lib.mkForce "${hostname}-c";
        networking.useHostResolvConf = false;
        services.tailscale.enable = false;
        # TODO get agenix working in containers for real?
        age.identityPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
      }
    ];
  };
in
{
  inherit options;

  config = lib.mkIf (cfg.enable && enabledHosts != { }) {
    containers = builtins.mapAttrs mkContainer enabledHosts;
  };
}
