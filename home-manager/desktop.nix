{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gitAndTools.git-annex
        moreutils
        ouch
        tig
        manix
        sd
        diceware
        transmission_4
        nvtopPackages.amd
        (pkgs.symlinkJoin {
          name = "timg-wrapped";
          paths = [ pkgs.timg ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/timg --add-flags '-pk'";
        })
        inputs.qbpm.packages.${pkgs.system}.qbpm
      ];

      programs.direnv = {
        enable = true;
        enableBashIntegration = false;
        nix-direnv.enable = true;
      };
      services.lorri.enable = true;

      programs.nix-index.enable = true;
      programs.tealdeer.enable = true;
      programs.jq.enable = true;
    };
}
