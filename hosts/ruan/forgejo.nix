{ config, ... }:
let
  hosts = config.flake.nixosConfigurations;
in
{
  flake.modules.nixos.ruan =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      waitForTailscale = lib.mkIf config.services.tailscale.enable {
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
      };
    in
    {
      networking.firewall.allowedTCPPorts = [
        40091
        32230
      ];

      local.caddy-gateway.internalProxies."code.pvsr.dev" = "code.ts.peterrice.xyz";

      systemd.services."container@forgejo" = waitForTailscale;

      local.containers.forgejo = {
        environment = {
          systemPackages = [ pkgs.forgejo ];
          sessionVariables.FORGEJO_WORK_DIR = "/var/lib/forgejo";
        };

        services.tsnsrv = {
          enable = true;
          services.code = {
            upstreamUnixAddr = "/run/forgejo/forgejo.sock";
            toURL = "http://code.pvsr.dev";
            plaintext = true;
            listenAddr = ":80";
          };
        };

        services.forgejo = {
          enable = true;
          package = pkgs.forgejo;
          settings = {
            server = {
              PROTOCOL = "http+unix";
              HTTP_ADDR = "/run/forgejo/forgejo.sock";
              DOMAIN = "code.pvsr.dev";
              ROOT_URL = "https://code.pvsr.dev";
              HTTP_PORT = 80;
              START_SSH_SERVER = true;
              SSH_DOMAIN = "ruan.ts.peterrice.xyz";
              SSH_PORT = 32230;
              SSH_LISTEN_HOST = config.local.tailscale.ip;
              SSH_LISTEN_PORT = 32230;
              BUILTIN_SSH_SERVER_USER = "git";
            };
            session.COOKIE_SECURE = true;
            DEFAULT.APP_NAME = "code.pvsr.dev";
            "ui.meta" = {
              AUTHOR = "code.pvsr.dev";
              DESCRIPTION = "code.pvsr.dev";
            };
            i18n = {
              LANGS = "en-US";
              NAMES = "English";
            };
            other = {
              SHOW_FOOTER_VERSION = false;
              SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
              SHOW_FOOTER_POWERED_BY = false;
            };
            repository = {
              PREFERRED_LICENSES = "MIT,GPL-3.0-or-later,AGPL-3.0-or-later";
              ENABLE_PUSH_CREATE_USER = true;
              DEFAULT_PUSH_CREATE_PRIVATE = false;
              DISABLED_REPO_UNITS = "repo.issues,repo.ext_issues,repo.pulls,repo.wiki,repo.ext_wiki,repo.projects,repo.packages,repo.actions";
              DISABLE_STARS = true;
              DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
            };
            "repository.upload".ENABLED = false;
            service = {
              DISABLE_REGISTRATION = true;
            };
            openid.ENABLE_OPENID_SIGNIN = false;
            oauth2.ENABLED = false;
            security = {
              INSTALL_LOCK = true;
              REVERSE_PROXY_TRUSTED_PROXIES = builtins.concatStringsSep "," hosts.crossbell.config.services.headscale.settings.ip_prefixes;
              LOGIN_REMEMBER_DAYS = 365;
            };
            api.ENABLE_SWAGGER = false;
            cache = {
              ADAPTER = "twoqueue";
              HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
            };
          };
        };
      };
    };
}
