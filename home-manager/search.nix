{ lib, ... }:
let
  mkEngines = pkgs: searchTerms: {
    kagi = {
      name = "Kagi";
      urls = [
        { template = "https://kagi.com/search?q=${searchTerms}"; }
        {
          template = "https://kagi.com/api/autosuggest?q=${searchTerms}";
          type = "application/x-suggestions+json";
        }
      ];
      icon = "https://github.com/kagisearch/browser_extensions/blob/e65c723370a2ee3960120612d2d46f3c9bfb6d87/shared/icons/icon_32px.png?raw=true";
      definedAliases = [ "k" ];
    };
    youtube = {
      urls = [ { template = "https://www.youtube.com/results?search_query=${searchTerms}"; } ];
      icon = "https://www.youtube.com/s/desktop/271dfaff/img/favicon_144x144.png";
      definedAliases = [ "y" ];
    };
    github = {
      urls = [ { template = "https://github.com/search?type=repositories&q=${searchTerms}"; } ];
      icon = "https://github.githubassets.com/favicons/favicon.svg";
      definedAliases = [ "gi" ];
    };
    wiktionary = {
      name = "Wiktionary";
      urls = [
        {
          template = "https://www.wiktionary.org/search-redirect.php?family=wiktionary&language=en&go=Go&search=${searchTerms}";
        }
      ];
      icon = "https://en.wiktionary.org/static/favicon/wiktionary/en.ico";
      definedAliases = [ "wikt" ];
    };
    jisho = {
      name = "Jisho";
      urls = [ { template = "https://jisho.org/search/${searchTerms}"; } ];
      icon = "https://assets.jisho.org/assets/favicon-062c4a0240e1e6d72c38aa524742c2d558ee6234497d91dd6b75a182ea823d65.ico";
      definedAliases = [ "ji" ];
    };
    rateyourmusic = {
      name = "RateYourMusic";
      urls = [ { template = "https://rateyourmusic.com/search?searchtype=&searchterm=${searchTerms}"; } ];
      icon = "https://e.snmc.io/3.0/img/logo/sonemic-32.png";
      definedAliases = [ "ra" ];
    };
    genius = {
      name = "Genius";
      urls = [ { template = "https://genius.com/search?q=${searchTerms}"; } ];
      icon = "https://genius.com/favicon.ico";
      definedAliases = [ "@gen" ];
    };
    nix-packages = {
      name = "Nix Packages";
      urls = [
        { template = "https://search.nixos.org/packages?channel=unstable&query=${searchTerms}"; }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@nxp" ];
    };
    nixos-options = {
      name = "NixOS Options";
      urls = [ { template = "https://search.nixos.org/options?channel=unstable&query=${searchTerms}"; } ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@nxo" ];
    };
    nixos-wiki = {
      name = "NixOS Wiki";
      urls = [ { template = "https://wiki.nixos.org/w/index.php?search=${searchTerms}"; } ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@nxw" ];
    };
    placeholder = {
      name = "Python Documentation";
      urls = [
        {
          template = "https://docs.python.org/3/search.html?check_keywords=yes&area=default&q=${searchTerms}";
        }
      ];
      icon = "https://docs.python.org/3/_static/py.svg";
      definedAliases = [ "pd" ];
    };
  };
  updateInterval = 7 * 24 * 60 * 60 * 1000;
  toQbEngine = n: v: lib.nameValuePair (lib.removePrefix "@" n) v;
  mkQbEngines =
    pkgs:
    lib.mapAttrs' (
      n: v: toQbEngine (builtins.elemAt v.definedAliases 0) (builtins.elemAt v.urls 0).template
    ) (mkEngines pkgs "{}");
in
{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    {
      programs.firefox.profiles.default.search = {
        force = true;
        default = "kagi";
        engines = {
          bing.metaData.hidden = true;
          ebay.metaData.hidden = true;
          amazondotcom-us.metaData.hidden = true;
          google.metaData.hidden = true;
          ddg.metaData.hidden = true;
          wikipedia.metaData.alias = "w";
        }
        // builtins.mapAttrs (n: v: { inherit updateInterval; } // v) (mkEngines pkgs "{searchTerms}");
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      qbEngines = mkQbEngines pkgs;
    in
    {
      programs.qutebrowser.searchEngines = {
        DEFAULT = qbEngines.k;
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}";
        d = "https://duckduckgo.com/?q={}";
        # TODO set these up in firefox too
        a = "https://wiki.archlinux.org/?search={}";
        ap = "https://archlinux.org/packages/?q={}";
        aur = "https://aur.archlinux.org/packages.php?K={}";
      }
      // qbEngines;
    };
}
