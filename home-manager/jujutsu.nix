{ lib, ... }:
{
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Peter Rice";
          email = lib.mkDefault "peterrice@fastmail.com";
        };
        git.auto-local-branch = true;
        ui.diff.format = "git";
      };
    };
    fish.shellAbbrs.j = "jj";
  };
}
