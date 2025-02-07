systemBuilders: with systemBuilders; {
  nixosConfigurations = {
    grancel = nixosStable ./grancel ../home-manager/grancel.nix;
    ruan = nixosStable ./ruan ../home-manager/ruan.nix;
    crossbell = nixosStable ./crossbell ../home-manager/crossbell.nix;
  };

  nixOnDroidConfigurations.default = nixOnDroidStable ./arseille;
}
