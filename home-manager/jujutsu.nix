{ lib, ... }:
{
  flake.modules.homeManager.core.programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Peter Rice";
          email = lib.mkDefault "peterrice@fastmail.com";
        };
        git.auto-local-bookmark = true;
        ui.default-command = "log";
        ui.diff-formatter = ":git";
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
            concat("(",
              self.parents().map(|parent| parent.change_id().shortest()).join("/"),
              " -> ",
              format_short_change_id_with_hidden_and_divergent_info(self),
              ")",
            ),
            bookmarks,
            tags,
            if(conflict, label("conflict", "×")),
            if(empty, label("empty", "(empty)")),
            if(description,
              concat("(", description.first_line(), ")"),
              if(!empty, description_placeholder),
            ),
          )
        '';
        template-aliases."in_branch(commit)" = "commit.contained_in(\"immutable_heads()..bookmarks()\")";
        templates.log_node = ''
          if(self && !current_working_copy && !immutable && !conflict && in_branch(self),
            "◇",
            builtin_log_node
          )
        '';
      };
    };
    fish = {
      shellAbbrs = {
        j = "jj";
        js = "jj show";
      };
      functions = {
        fish_vcs_prompt = "fish_jj_prompt $argv; or fish_git_prompt $argv; or fish_hg_prompt $argv";
        # https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_jj_prompt.fish
        fish_jj_prompt = ''
          set -l info "$(jj log \
            --ignore-working-copy \
            --revisions @ \
            --no-graph \
            --color=always \
            --template shell_prompt \
            2>/dev/null)"
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
              -T 'separate("\n", separate(" ",
                format_timestamp(commit_timestamp(self)),
                format_short_commit_id(self.commit_id())
              ), self.description())' \
            | string collect)
            PAGER=cat jj show $argv[1]
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
