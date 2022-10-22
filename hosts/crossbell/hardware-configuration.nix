{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  boot.loader.grub.device = "/dev/vda";

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  networking.useDHCP = lib.mkDefault true;

  # virtualisation.hypervGuest.enable = true;
}
