{ pkgs, ... }: {
  programs.steam.enable = true;

  environment.systemPackages = [
    (pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
    })
  ];
}
