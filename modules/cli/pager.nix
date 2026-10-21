{
  flake.modules.hjem.core =
    { pkgs, ... }:
    {
      packages = [ pkgs.moor ];

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
