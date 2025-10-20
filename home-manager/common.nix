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
      };

      home.language.base = "en-US.UTF-8";

      home.shellAliases.bell = "echo \\a";

      programs.bottom.enable = true;
      programs.zoxide.enable = true;
    };
}
