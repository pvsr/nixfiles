{ inputs, ... }:
{
  flake.modules.nixos.core =
    { config, lib, ... }:
    let
      cfg = config.local.persistence;
      username = config.local.user.name;
      persistCfg = config.environment.persistence;
      persistDir = persistCfg.nixos.persistentStoragePath;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.local.persistence = {
        enable = lib.mkEnableOption { };
        rootDevice = lib.mkOption {
          type = lib.types.path;
        };
      };

      config = {
        users = lib.mkIf cfg.enable {
          mutableUsers = false;
          users.root.hashedPasswordFile = "${persistDir}/passwords/root";
          users.${username}.hashedPasswordFile = "${persistDir}/passwords/${username}";
        };

        environment.persistence.nixos = {
          inherit (cfg) enable;
          directories = [
            "/etc/nixos"
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd"
          ];
          files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
          ];
        };

        boot.initrd.systemd.services.init-root = lib.mkIf cfg.enable {
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
            mount --mkdir ${cfg.rootDevice} /mnt

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
    };
}
