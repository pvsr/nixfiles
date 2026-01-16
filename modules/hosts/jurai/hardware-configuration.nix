{
  local.desktops.jurai =
    {
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    let
      onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    in
    {
      imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

      boot.initrd.availableKernelModules = [ "xhci_pci" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/run/media/host" = lib.mkIf onMacos {
        device = "share";
        fsType = "virtiofs";
      };
    };
}
