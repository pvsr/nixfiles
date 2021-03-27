{ pkgs, ... }: {
  #imports = [ ./fish ./neovim ];

  #environment.shellAliases = { v = "$EDITOR"; pass = "gopass"; };

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    direnv
    file
    jq
    manpages
    tig
    tokei
  ];

  documentation.dev.enable = true;
}
