{ self, config, ... }:
let
  hosts = config.flake.nixosConfigurations;
  domain = "code.ruan.ygg.pvsr.dev";
in
{
  flake.modules.nixos.core.networking.hosts.${hosts.ruan.config.local.ip} = [
    "code.pvsr.dev"
  ];

  flake.modules.nixos.ruan.local.caddy.internalProxies."code.pvsr.dev" = "${domain}:3000";

  local.containers.code =
    {
      modulesPath,
      config,
      pkgs,
      ...
    }:
    {
      # TODO move to container defaults
      imports = [
        "${modulesPath}/profiles/minimal.nix"
        self.modules.nixos.user
      ];
      system.stateVersion = "26.05";
      users.defaultUserShell = pkgs.fishMinimal;
      security.sudo.wheelNeedsPassword = false;

      environment = {
        systemPackages = [ pkgs.forgejo ];
        sessionVariables.FORGEJO_WORK_DIR = "/var/lib/forgejo";
      };

      networking.firewall.allowedTCPPorts = [
        3000
        22
        2222
      ];

      services.forgejo = {
        enable = true;
        package = pkgs.forgejo;
        settings = {
          server = {
            PROTOCOL = "http";
            HTTP_ADDR = "::";
            HTTP_PORT = 3000;
            DOMAIN = "code.pvsr.dev";
            ROOT_URL = "https://code.pvsr.dev";
            START_SSH_SERVER = true;
            SSH_DOMAIN = "${domain}";
            SSH_PORT = 2222;
            SSH_LISTEN_HOST = "::";
            SSH_LISTEN_PORT = 2222;
            BUILTIN_SSH_SERVER_USER = "git";
          };
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
}
