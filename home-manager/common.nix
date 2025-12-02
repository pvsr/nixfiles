{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        fd
        moor
        nvd
        nil
        nix-output-monitor
        duf
        dust
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
      ];

      home.sessionVariables = {
        PAGER = "${pkgs.moor}/bin/moor";
        MOOR = builtins.concatStringsSep " " [
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
