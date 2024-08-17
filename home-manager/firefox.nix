{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      search = {
        force = true;
        default = "Kagi";
        engines =
          let
            weekly = 7 * 24 * 60 * 60 * 1000;
          in
          {
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Google".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "Wikipedia (en)".metaData.alias = "w";
            "Kagi" = {
              urls = [
                { template = "https://kagi.com/search?q={searchTerms}"; }
                {
                  template = "https://kagi.com/api/autosuggest?q={searchTerms}";
                  type = "application/x-suggestions+json";
                }
              ];
              iconUpdateURL = "https://github.com/kagisearch/browser_extensions/blob/e65c723370a2ee3960120612d2d46f3c9bfb6d87/shared/icons/icon_32px.png?raw=true";
              updateInterval = weekly;
              definedAliases = [ "k" ];
            };
            "YouTube" = {
              urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
              iconUpdateURL = "https://www.youtube.com/s/desktop/271dfaff/img/favicon_144x144.png";
              updateInterval = weekly;
              definedAliases = [ "y" ];
            };
            "GitHub" = {
              urls = [ { template = "https://github.com/search?type=repositories&q={searchTerms}"; } ];
              iconUpdateURL = "https://github.githubassets.com/favicons/favicon.svg";
              updateInterval = weekly;
              definedAliases = [ "gi" ];
            };
            "Wiktionary" = {
              urls = [
                {
                  template = "https://www.wiktionary.org/search-redirect.php?family=wiktionary&language=en&go=Go&search={searchTerms}";
                }
              ];
              iconUpdateURL = "https://en.wiktionary.org/static/favicon/wiktionary/en.ico";
              updateInterval = weekly;
              definedAliases = [ "wikt" ];
            };
            "Jisho" = {
              urls = [ { template = "https://jisho.org/search/{searchTerms}"; } ];
              iconUpdateURL = "https://assets.jisho.org/assets/favicon-062c4a0240e1e6d72c38aa524742c2d558ee6234497d91dd6b75a182ea823d65.ico";
              updateInterval = weekly;
              definedAliases = [ "ji" ];
            };
            "RateYourMusic" = {
              urls = [ { template = "https://rateyourmusic.com/search?searchtype=&searchterm={searchTerms}"; } ];
              iconUpdateURL = "https://e.snmc.io/3.0/img/logo/sonemic-32.png";
              updateInterval = weekly;
              definedAliases = [ "ra" ];
            };
            "Genius" = {
              urls = [ { template = "https://genius.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://genius.com/favicon.ico";
              updateInterval = weekly;
              definedAliases = [ "@gen" ];
            };
            "Nix Packages" = {
              urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@np"
                "@nxp"
              ];
            };
            "NixOS Options" = {
              urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nxo"
                "@no"
              ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nxw"
                "@nw"
              ];
            };
            "Python Documentation" = {
              urls = [
                {
                  template = "https://docs.python.org/3/search.html?check_keywords=yes&area=default&q={searchTerms}";
                }
              ];
              iconUpdateURL = "https://docs.python.org/3/_static/py.svg";
              updateInterval = weekly;
              definedAliases = [ "pd" ];
            };
          };
      };
    };
  };
}
