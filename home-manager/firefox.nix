{ pkgs, lib, ... }:
{
  imports = [ ./search.nix ];

  programs.firefox = {
    enable = true;
    package = lib.mkDefault (pkgs.firefox.override { cfg.speechSynthesisSupport = false; });
    policies = {
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
    profiles.default = {
      name = "default";
    };
  };
}
