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
        git.auto-local-bookmark = true;
        ui.default-command = "log";
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
        template-aliases.shell_prompt = ''
          separate(" ",
            format_short_change_id_with_hidden_and_divergent_info(self),
            bookmarks,
            tags,
            if(conflict, label("conflict", "×")),
            if(empty, label("empty", "(empty)")),
            if(description,
              description.first_line(),
              if(!empty, description_placeholder),
            ),
          )
        '';
      };
    };
    fish = {
      shellAbbrs.j = "jj";
      functions = {
        # https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_jj_prompt.fish
        fish_jj_prompt = ''
          set -l info "$(jj log 2>/dev/null --no-graph \
            --color=always --revisions @ --template shell_prompt)"
          or return 1
          if test -n "$info"
            printf ' %s' $info
          end
        '';
        summarize = {
          wraps = "jj show";
          body = ''
            set recent (jj log --no-graph \
              -r 'ancestors(immutable_heads(), 8) & ~description("flake.lock")' \
              -T 'separate("\n", separate(" ", \
                format_timestamp(commit_timestamp(self)), \
                format_short_commit_id(self.commit_id()) \
              ), self.description())' \
            | string collect)
            PAGER= jj show $argv[1]
            jj show $argv[1] | llm -s "Write a one-line commit message for \
            these changes. It should be under 50 characters. If a terse \
            description does not fit in 50 characters you may continue to write \
            one or more paragraphs describing the changes, which should be \
            wrapped at 80 characters. It should match the style of these recent \
            commit messages in the same repository:
            $recent

            Include the commit message and nothing else, fenced in triple \
            backticks like so:
            ```
            commit message, less than 50 characters

            optional commit description
            ```
            "
          '';
        };
      };
    };
  };
}
