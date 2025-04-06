{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.local.machines;
  enabledHosts = lib.filterAttrs (
    hostname: host: lib.elem hostname cfg.only && host ? containerId
  ) cfg.hosts;
  mkContainer = host: {
    specialArgs.inputs = inputs;
    autoStart = host.autoStart or cfg.autoStart;
    privateNetwork = true;
    hostAddress = "192.168.100.100";
    localAddress = "192.168.100.${toString host.containerId}";
    hostAddress6 = "fc00::100";
    localAddress6 = "fc00::${toString host.containerId}";
    config.imports = [
      host.module
      ../modules/nixos.nix
      {
        disabledModules = [
          ../modules/niri.nix
          ../modules/steam.nix
          ../modules/gnome.nix
          ../modules/tailscale.nix
          inputs.srvos.nixosModules.hardware-vultr-vm
          inputs.nixos-hardware.nixosModules.common-gpu-amd
        ];
        networking.useHostResolvConf = false;
        # TODO get agenix working in containers for real?
        age.identityPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
      }
    ];
  };
in
{
  options.local.machines = {
    enable = lib.mkEnableOption { };
    autoStart = lib.mkOption { default = true; };
    hosts = lib.mkOption { default = { }; };
    only = lib.mkOption { default = builtins.attrNames cfg.hosts; };
  };

  config = lib.mkIf (cfg.enable && cfg.hosts != { }) {
    containers = builtins.mapAttrs (_: mkContainer) enabledHosts;
  };
}
