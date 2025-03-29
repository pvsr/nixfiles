{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
in
{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/media/host" = lib.mkIf onMacos {
    device = "share";
    fsType = "virtiofs";
  };
}
