{
  flake.modules.hjem.core =
    { lib, pkgs, ... }:
    {
      packages = with pkgs; [
        fd
        moor
        nvd
        nil
        nix-output-monitor
        duf
        dust
        bottom
        zoxide
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
      ];

      environment.sessionVariables = {
        PAGER = "moor";
        MOOR = builtins.concatStringsSep " " [
          "-quit-if-one-screen"
          "-statusbar=bold"
          "-no-statusbar"
          "-no-linenumbers"
          "-no-clear-on-exit"
          "-terminal-fg"
        ];
      };
    };
}
