{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["defaults" "compress=zstd"];
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  # virtualisation.hypervGuest.enable = true;
}
