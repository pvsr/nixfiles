{ lib, ... }:
let
  settings = {
    user.name = "Peter Rice";
    user.email = lib.mkDefault "peterrice@fastmail.com";
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
in
{
  flake.modules.hjem.core =
    { pkgs, ... }:
    {
      packages = [
        pkgs.git
        pkgs.fishPlugins.plugin-git
      ];

      xdg.config.files = {
        "git/config" = {
          generator = lib.generators.toGitINI;
          value = settings;
        };
        "git/ignore".text = ''
          .envrc
          .direnv
          result*
          *.qcow2
          *.fd
          .nixos-test-history
        '';
      };

      fish.interactiveShellInit = ''
        __git.init
        abbr gcp 'git commit -p'
        abbr gcp! 'git commit -p --amend'
        abbr gcpn! 'git commit -p --no-edit --amend'
      '';
    };
}
