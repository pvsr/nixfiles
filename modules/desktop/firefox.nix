{
  flake.modules.hjem.firefox =
    { pkgs, ... }:
    {
      packages = [
        (pkgs.firefox.override {
          cfg.speechSynthesisSupport = false;
          extraPolicies = {
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
        })
      ];
      niri.extraConfig = ''
        window-rule {
          match app-id="firefox$" title="^Picture-in-Picture$"
          open-floating true
        }
      '';
    };
}
