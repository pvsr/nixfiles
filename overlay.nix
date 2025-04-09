inputs: final: prev:
let
  system = prev.stdenv.hostPlatform.system;
  unstable = inputs.unstable.legacyPackages.${system};
in
{
  inherit (unstable)
    moar
    jj
    fish
    fishMinimal
    ;
  inherit (inputs.qbpm.packages.${system}) qbpm;
  inherit (inputs.agenix.packages.${system}) agenix;
  inherit (inputs.helix.packages.${system}) helix;
  transmission = prev.transmission_4;
  tmuxPlugins = prev.tmuxPlugins // {
    srcery = prev.tmuxPlugins.mkTmuxPlugin {
      pluginName = "srcery";
      version = inputs.srcery-tmux.shortRev;
      src = inputs.srcery-tmux;
    };
  };
  fishPlugins = prev.fishPlugins // {
    fish-prompt-pvsr = prev.fishPlugins.buildFishPlugin {
      pname = "fish-prompt-pvsr";
      version = inputs.fish-prompt-pvsr.shortRev;
      src = inputs.fish-prompt-pvsr;
    };
  };
  timg = prev.symlinkJoin {
    name = "timg-wrapped";
    paths = [ prev.timg ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = "wrapProgram $out/bin/timg --add-flags '-pk'";
  };
}
// (inputs.niri.overlays.niri final prev)
