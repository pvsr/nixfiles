{ inputs, ... }:
{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (fzf.overrideAttrs (oldAttrs: {
          postInstall = ''
            ${oldAttrs.postInstall or ""}
            rm -rf $out/share/fish
          '';
        }))
        (pkgs.fishPlugins.buildFishPlugin {
          pname = "fzf-fish";
          src = inputs.fzf-fish;
          version = inputs.fzf-fish.shortRev;
        })
      ];

      home.sessionVariables.FZF_DEFAULT_OPTS = builtins.concatStringsSep " " [
        "--bind=${
          builtins.concatStringsSep "," [
            "ctrl-j:accept"
            "ctrl-k:kill-line"
            "alt-j:preview-down"
            "alt-k:preview-up"
            "ctrl-f:preview-page-down"
            "ctrl-b:preview-page-up"
            "ctrl-d:preview-half-page-down"
            "ctrl-u:preview-half-page-up"
          ]
        }"
        "--cycle"
        "--layout=reverse"
      ];
    };
}
