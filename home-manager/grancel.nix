{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./nixos.nix
    ./tasks.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.amd
    sptlrx
  ];

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override {withMpris = true;};
    settings.global = {
      username_cmd = "${pkgs.pass}/bin/pass show spotify/userid";
      password_cmd = "${pkgs.pass}/bin/pass show spotify.com";
      backend = "pulseaudio";
    };
  };

  services.mpris-proxy.enable = true;
}
