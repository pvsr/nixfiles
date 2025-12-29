{
  flake.modules.hjem.desktop =
    { pkgs, ... }:
    {
      packages = [ pkgs.direnv ];
      fish.interactiveShellInit = "${pkgs.direnv}/bin/direnv hook fish | source";
      xdg.config.files."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
}
