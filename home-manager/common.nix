{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        fd
        moar
        nvd
        nil
        nix-output-monitor
        duf
        du-dust
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })
        (fzf.overrideAttrs (oldAttrs: {
          postInstall = ''
            ${oldAttrs.postInstall or ""}
            rm -rf $out/share/fish
          '';
        }))
      ];

      programs.bat.enable = true;
      programs.bat.config.theme = "ansi";

      home.sessionVariables = {
        MANPAGER = pkgs.writeShellScript "batman" ''
          awk '{ gsub(/\x1B\[[0-9;]*m/, "", $0); gsub(/.\x08/, "", $0); print }' \
          | bat --plain --language man
        '';
        PAGER = "${pkgs.moar}/bin/moar";
        MOAR = builtins.concatStringsSep " " [
          "-quit-if-one-screen"
          "-statusbar=bold"
          "-no-statusbar"
          "-no-linenumbers"
          "-no-clear-on-exit"
          "-terminal-fg"
        ];
        FZF_DEFAULT_OPTIONS = builtins.concatStringsSep " " [
          "--bind=ctrl-j:accept,ctrl-k:kill-line"
          "--cycle"
          "--layout=reverse"
        ];
      };

      home.language.base = "en-US.UTF-8";

      home.shellAliases.bell = "echo \\a";

      programs.bottom.enable = true;
    };
}
