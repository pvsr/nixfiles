{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.local.impermanence;
  userCfg = config.users.users.peter;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.local.impermanence = {
    enable = lib.mkEnableOption { };
    device = lib.mkOption { };
    persist = lib.mkOption { };
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf (cfg.enable && !config.boot.isContainer) {
    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "${cfg.persist}/passwords/root";
    users.users.peter.hashedPasswordFile = "${cfg.persist}/passwords/peter";

    virtualisation =
      let
        variant = {
          users.users.root.hashedPasswordFile = lib.mkForce null;
          users.users.peter.hashedPasswordFile = lib.mkForce null;

          # https://github.com/NixOS/nixpkgs/issues/6481
          systemd.tmpfiles.rules = [
            "d ${userCfg.home} ${userCfg.homeMode} ${userCfg.name} ${userCfg.group}"
          ];

        };
      in
      {
        vmVariant = variant;
        vmVariantWithDisko = variant;
      };

    age.identityPaths = [ "${cfg.persist}/etc/ssh/ssh_host_ed25519_key" ];

    environment.persistence.${cfg.persist} = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/machines"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/lib/tailscale"
        "/etc/nixos"
      ] ++ cfg.directories;
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    boot.initrd.systemd.services.init-root = {
      wantedBy = [ "initrd.target" ];
      after = [ "initrd-root-device.target" ];
      before = [ "create-needed-for-boot-dirs.service" ];
      description = "Create Fresh Root Subvolume";
      unitConfig = {
        DefaultDependencies = false;
      };
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        mount --mkdir ${cfg.device} /mnt

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/mnt/$i"
            done
            btrfs subvolume delete "$1"
        }

        if [[ -e /mnt/tmp_root ]]; then
          if [[ -e /mnt/old_root ]]; then
            btrfs subvolume delete /mnt/old_root
          fi
          btrfs subvolume snapshot -r /mnt/tmp_root /mnt/old_root
          delete_subvolume_recursively /mnt/tmp_root
        fi

        btrfs subvolume create /mnt/tmp_root
        umount /mnt
      '';
    };
  };
}
