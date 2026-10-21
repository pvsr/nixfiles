{
  flake.modules.hjem.core =
    { lib, pkgs, ... }:
    {
      packages = with pkgs; [
        fd
        nh
        dix
        nil
        nix-output-monitor
        duf
        dust
        bottom
        zoxide
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
      ];
    };
}
