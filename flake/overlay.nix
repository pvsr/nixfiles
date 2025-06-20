{ self, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      system,
      pkgs,
      inputs',
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          inputs.niri.overlays.niri
        ];
      };

      overlayAttrs = {
        inherit (inputs'.qbpm.packages) qbpm;
        inherit (inputs'.helix.packages) helix;
        transmission = pkgs.transmission_4;
        tmuxPlugins = pkgs.tmuxPlugins // {
          srcery = pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "srcery";
            version = inputs.srcery-tmux.shortRev;
            src = inputs.srcery-tmux;
          };
        };
        fishPlugins = pkgs.fishPlugins // {
          fish-prompt-pvsr = pkgs.fishPlugins.buildFishPlugin {
            pname = "fish-prompt-pvsr";
            version = inputs.fish-prompt-pvsr.shortRev;
            src = inputs.fish-prompt-pvsr;
          };
        };
        timg = pkgs.symlinkJoin {
          name = "timg-wrapped";
          paths = [ pkgs.timg ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/timg --add-flags '-pk'";
        };
      };
    };
}
