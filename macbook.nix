{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
  ];

  #packageOverrides = pkgs: rec {
  #  maven = pkgs.maven.override {
  #    jre = pkgs.jdk11;
  #  };
  #};

  #programs.java = {
  #  enable = true;
  #  package = pkgs.jdk1;
  #};

  programs.fish = {
    enable = true;
    functions.mysql = builtins.readFile ~/dev/personal/scripts/mysql.fish;
    shellAbbrs = {
      suod = "sudo";
    };
    shellAliases.rmi = "hub --git-dir=(realpath ~/dev/report-management-issues/.git) issue";
  };

  programs.git.userEmail = "price@hubspot.com";
  # TODO I don't think this will work
  programs.alacritty.settings.font.size = mkForce 13.0;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
