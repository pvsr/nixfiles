{
  # https://github.com/helix-editor/helix/issues/966#issuecomment-3877313441
  flake.modules.hjem.core =
    { pkgs, ... }:
    let
      handleInput = # bash
        ''
          expression="''${1:-div}"
          stdin="$(cat)"

          tag=$(printf '%s' "$expression" | sed -n 's/\([^.#]*\).*/\1/p')
          expression="''${expression:''${#tag}}"

          id="$(printf '%s' "''${expression}" | sed -n 's/.*#\([^.#]*\).*/\1/p')"
          expression="$(printf '%s' "$expression" | sed "s/#$id//")"

          class="$(printf '%s' "$expression" | tr '.' ' ')"
          class="''${class#"''${class%%[![:space:]]*}"}"
          class="''${class%"''${class##*[![:space:]]}"}"

          tagopen="$tag"
          if [ -n "$id" ]; then tagopen="$tagopen id=\"$id\""; fi
          if [ -n "$class" ]; then tagopen="$tagopen class=\"$class\""; fi
        '';
      wrap-newline = pkgs.writeShellScriptBin "tag-wrap-newline" ''
        ${handleInput}
        content="$(printf '%s' "$stdin" | sed 's/^/  /')"
        whitespace=$(printf '%s' "$stdin" | grep -o '^[[:space:]]*' | head -n1)

        printf '%s\n' "$whitespace<$tagopen>"
        printf '%s\n' "$content"
        printf '%s\n' "$whitespace</$tag>"
      '';
      wrap-inline = pkgs.writeShellScriptBin "tag-wrap-inline" ''
        ${handleInput}
        content="$(printf '%s' "$stdin")"

        printf '%s' "<$tagopen>$content</$tag>"
      '';
    in
    {
      packages = [
        wrap-newline
        wrap-inline
      ];

      helix.settings.keys = {
        normal.m.t = "@|tag-wrap-inline ";
        select.m.t = "@|tag-wrap-inline ";

        normal.m.T = "@|tag-wrap-newline ";
        select.m.T = "@|tag-wrap-newline ";
      };
    };
}
