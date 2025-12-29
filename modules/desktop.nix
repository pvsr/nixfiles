{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [
      inputs.self.modules.nixos.yggdrasil-client
      inputs.srvos.nixosModules.desktop
    ];

    nix.extraOptions = "keep-outputs = true";
    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = "75%";
    };

    services.lorri.enable = true;
  };

  flake.modules.hjem.desktop =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        git-annex
        moreutils
        ouch
        tig
        jq
        nix-index
        manix
        tealdeer
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
        inputs.qbpm.packages.${pkgs.stdenv.hostPlatform.system}.qbpm
      ];
    };
}
