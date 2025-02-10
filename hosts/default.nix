systemBuilders: with systemBuilders; {
  nixosConfigurations = {
    grancel = nixosUnstable ./grancel ../home-manager/grancel.nix;
    ruan = nixosStable ./ruan ../home-manager/ruan.nix;
    crossbell = nixosStable ./crossbell ../home-manager/common.nix;
    jurai = nixosStable ./jurai ../home-manager/nixos.nix;
  };

  nixOnDroidConfigurations.default = nixOnDroidUnstable ./arseille ../home-manager/arseille.nix;
}
