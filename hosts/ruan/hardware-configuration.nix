{ inputs, ... }:
{
  flake.modules.nixos.ruan = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
      inputs.nixos-hardware.nixosModules.common-gpu-amd
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "uas"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [
        "subvol=tmp_root"
        "defaults"
        "compress=zstd"
      ];
    };

    fileSystems."/media/nixos" = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      neededForBoot = true;
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "defaults"
        "compress=zstd"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "defaults"
        "compress=zstd"
      ];
    };

    fileSystems."/var/lib/swap" = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/AB78-74B8";
      fsType = "vfat";
      options = [
        "defaults"
        "umask=0077"
      ];
    };

    fileSystems."/media/data" = {
      device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
      ];
    };

    fileSystems."/media/leiston" = {
      device = "/dev/disk/by-uuid/c76abfad-5b5a-478f-a85e-dde18ffe202f";
      fsType = "btrfs";
      options = [
        "nofail"
        "defaults"
        "compress=zstd"
      ];
    };

    swapDevices = [ { device = "/var/lib/swap/swapfile"; } ];
  };
}
