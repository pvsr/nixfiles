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
        templates.draft_commit_description = ''
          concat(
            description,
            separate("\n",
              "\nJJ: This commit contains the following changes:",
              indent("JJ:     ", diff.summary()),
              "JJ: ignore-rest",
              diff.git(),
            )
          )
        '';
      };
    };
    fish.shellAbbrs.j = "jj";
  };
}
