{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./alacritty.nix
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
    shellAbbrs = {
      suod = "sudo";
    };
    shellAliases.rmi = "hub --git-dir=(realpath ~/dev/report-management-issues/.git) issue";
  };

  programs.git.userEmail = "price@hubspot.com";
  programs.alacritty.settings.font.size = 16.0;
}
