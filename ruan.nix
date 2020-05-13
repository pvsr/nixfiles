{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ranger
    diceware
    beets
    qutebrowser
    mrsh
    termite
    psmisc
    jetbrains.idea-community
    tmux
  ];

  programs.tmux = {
    #enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "screen-256color";
    newSession = true;
    clock24 = true;
    extraConfig = "set -ga terminal-overrides \",xterm-termite:Tc\"";
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.gruvbox
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.sensible
    ];
    #extraConfig = "";
  };

  programs.fish = {
    enable = true;
    functions = {
    };
    interactiveShellInit = ''
      set -g fish_key_bindings fish_hybrid_key_bindings
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g FZF_COMPLETE

      test -z "$hostname"; and set hostname (uname -n)
      if test -f "$HOME/.keychain/$hostname-fish"
        source $HOME/.keychain/$hostname-fish
      end
      if test -f "$HOME/.keychain/$hostname-fish-gpg"
        source $HOME/.keychain/$hostname-fish-gpg
      end
    '';
    plugins = [
      {
        name = "mono";
        src = /home/peter/dev/mono;
        # src = pkgs.fetchFromGitHub {
        #   owner = "pvsr";
        #   repo = "mono";
        # };
      }
      {
        name = "fzf";
        src = /home/peter/dev/fzf;
      }
      {
        name = "fish-git-util";
        src = /home/peter/dev/fish-git-util;
      }
    ];
    shellAbbrs = {
      suod = "sudo";
    };
    shellAliases = {
      pass = "EDITOR=nvim_nowrite pass";
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      tree = "exa -T";
    };
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = false;
    agents = [ "gpg" "ssh" ];
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };

  programs.git = {
    enable = true;
    ignores = [ "Session.vim" ];
    userName = "Peter Rice";
    userEmail = "peter@peterrice.xyz";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--bind=ctrl-j:accept,ctrl-k:kill-line" ];
  };

  #services.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
