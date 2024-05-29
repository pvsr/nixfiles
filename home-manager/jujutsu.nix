{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Peter Rice";
          email = lib.mkDefault "peter@peterrice.xyz";
        };
      };
    };
    fish = {
      shellAbbrs = lib.mapAttrs (abbr: command: "jj ${command}") {
        jn = "new";
        jds = "describe";
        je = "edit";
        jc = "commit";
        jsp = "split";
        jsq = "squash";
        jr = "rebase";
        jl = "log";
        jb = "branch";
        jbs = "branch set";
        jd = "diff";
        jst = "status";
        jg = "git";
        jp = "git push";
      };
    };
  };
}
