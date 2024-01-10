inputs: final: prev: let
  system = prev.stdenv.hostPlatform.system;
  unstable = inputs.unstable.legacyPackages.${system};
in {
  inherit (inputs.qbpm.packages.${system}) qbpm;
  inherit (inputs.agenix.packages.${system}) agenix;
  transmission = prev.transmission_4;
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      srcery = prev.tmuxPlugins.mkTmuxPlugin {
        pluginName = "srcery";
        version = "git";
        src = inputs.srcery-tmux;
      };
    };
  fishPlugins =
    prev.fishPlugins
    // {
      fish-prompt-pvsr = prev.fishPlugins.buildFishPlugin {
        pname = "fish-prompt-pvsr";
        version = "git";
        src = inputs.fish-prompt-pvsr;
      };
    };
}
