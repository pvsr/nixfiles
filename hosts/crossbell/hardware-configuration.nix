{ lib, inputs, ... }:
{
  flake.modules.nixos.crossbell = {
    imports = [ inputs.nixos-hardware.nixosModules.common-pc-ssd ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    boot.initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    boot.loader.grub.devices = [ "/dev/vda" ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
      ];
    };

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

    # virtualisation.hypervGuest.enable = true;
  };
}
