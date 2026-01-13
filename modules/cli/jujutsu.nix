{ lib, ... }:
let
  settings = {
    user = {
      name = "Peter Rice";
      email = lib.mkDefault "peterrice@fastmail.com";
    };
    ui.default-command = "log";
    ui.diff-formatter = ":git";
    ui.diff-editor = ":builtin";
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
    aliases.tug = [
      "bookmark"
      "move"
      "--from"
      "heads(::@- & bookmarks())"
      "--to"
      "heads(::@ ~ empty())"
    ];
    template-aliases.shell_prompt = ''
      separate(" ",
        concat("(",
          self.parents().map(|parent| parent.change_id().shortest()).join("/"),
          " -> ",
          format_short_change_id_with_change_offset(self),
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
  path = "jj/config.toml";
in
{
  flake.modules.hjem.core =
    { pkgs, ... }:
    {
      packages = [ pkgs.jujutsu ];
      xdg.config.files.${path} = {
        generator = (pkgs.formats.toml { }).generate path;
        value = settings;
      };

      fish.interactiveShellInit = # fish
        ''
          abbr -a j  'jj'
          abbr -a js 'jj show'
        '';
      fish.functions.fish_vcs_prompt = # fish
        ''
          fish_jj_prompt $argv; or fish_git_prompt $argv; or fish_hg_prompt $argv
        '';
      fish.functions.fish_jj_prompt = # fish
        ''
          if not command -sq jj
            return 1
          end
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
      fish.wrappers."jj show".summarize = # fish
        ''
          set recent (jj log --no-graph \
            -r 'ancestors(immutable_heads(), 12) & ~description("flake.lock")' \
            -T 'separate("\n",
             format_short_commit_id(self.commit_id()),
             self.description())' \
          | string collect)
          jj show --no-pager --context 12 $argv[1] >&2
          jj show --no-pager --context 12 $argv[1] |\
          llm -s "Write a one-line commit message for these changes. It \
          should be under 50 characters. If 50 characters is not enough to \
          express the main point of the changes you may continue to write \
          one or more paragraphs describing the changes, which should be \
          wrapped at 80 characters.

          It should match the style of these recent commit messages in the \
          same repository, which are each prefixed by a hexadecimal commit \
          id and a newline:
          $recent

          Write the commit message with no commentary, as if the output \
          were going straight into the commit
          " | tee /dev/tty | jj desc --stdin --editor $argv[1]
        '';
    };
}
