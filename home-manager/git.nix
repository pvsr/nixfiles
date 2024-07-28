{
  config,
  pkgs,
  lib,
  ...
}: {
  config.programs.git = {
    enable = true;
    ignores = [".envrc" ".direnv"];
    userName = "Peter Rice";
    userEmail = lib.mkDefault "peterrice@fastmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      commit.verbose = true;
      interactive.singleKey = true;
      diff.algorithm = "patience";
      merge.conflictstyle = "zdiff3";
      pull.rebase = true;
      push.default = "current";
      rebase.autostash = true;
      rebase.autosquash = true;
      rebase.updateRefs = true;
      branch.autoSetupRebase = "always";
      branch.sort = "-committerdate";
      url."git@github.com:".insteadOf = "github:";
    };
  };
}
