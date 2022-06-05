{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AB78-74B8";
    fsType = "vfat";
  };

  fileSystems."/media/data" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
  };

  fileSystems."/var/lib/transmission" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
    options = ["subvol=transmission"];
  };

  fileSystems."/media/steam" = {
    device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
    fsType = "btrfs";
    options = ["subvol=steam"];
  };

  fileSystems."/media/nixos" = {
    device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
    fsType = "btrfs";
  };

  fileSystems."/media/leiston" = {
    device = "/dev/disk/by-uuid/c76abfad-5b5a-478f-a85e-dde18ffe202f";
    fsType = "btrfs";
  };

  swapDevices = [];

  hardware.video.hidpi.enable = lib.mkDefault true;
}
