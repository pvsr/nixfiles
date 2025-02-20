{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.impermanence = {
    enable = lib.mkEnableOption { };
    device = lib.mkOption { };
    persist = lib.mkOption { };
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    systemdInitrd = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "${cfg.persist}/passwords/root";
    users.users.peter.hashedPasswordFile = "${cfg.persist}/passwords/peter";

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

    boot.initrd =
      if cfg.systemdInitrd then
        {
          # TODO debug
          systemd.services.init-root = {
            wantedBy = [ "initrd.target" ];
            # TODO
            # requires = [
            #   "dev-disk-by\\x2dlabel-grancel.device"
            # ];
            # after = [
            #   "dev-disk-by\\x2dlabel-grancel.device"
            # ];
            before = [ "sysroot.mount" ];
            unitConfig.defaultDependencies = "no";
            serviceConfig.type = "oneshot";
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
        }
      else
        {
          systemd.enable = false;
          postDeviceCommands = lib.mkAfter ''
            mkdir /mnt
            mount ${cfg.device} /mnt

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
          '';
        };
  };
}
