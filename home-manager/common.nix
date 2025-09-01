{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        fd
        moar
        nvd
        nil
        nix-output-monitor
        duf
        du-dust
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
        (fzf.overrideAttrs (oldAttrs: {
          postInstall = ''
            ${oldAttrs.postInstall or ""}
            rm -rf $out/share/fish
          '';
        }))
      ];

      home.sessionVariables = {
        PAGER = "${pkgs.moar}/bin/moar";
        MOAR = builtins.concatStringsSep " " [
          "-quit-if-one-screen"
          "-statusbar=bold"
          "-no-statusbar"
          "-no-linenumbers"
          "-no-clear-on-exit"
          "-terminal-fg"
        ];
        FZF_DEFAULT_OPTIONS = builtins.concatStringsSep " " [
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

      home.language.base = "en-US.UTF-8";

      home.shellAliases.bell = "echo \\a";

      programs.bottom.enable = true;
    };
}
