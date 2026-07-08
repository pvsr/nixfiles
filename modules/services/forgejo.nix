{ self, ... }:
let
  domain = "code.pvsr.dev";
  settings = {
    server = {
      PROTOCOL = "http";
      HTTP_ADDR = "::";
      HTTP_PORT = 80;
      DOMAIN = domain;
      ROOT_URL = "https://${domain}";
      START_SSH_SERVER = true;
      SSH_LISTEN_HOST = "::";
      BUILTIN_SSH_SERVER_USER = "git";
    };
    DEFAULT.APP_NAME = domain;
    "ui.meta" = {
      AUTHOR = domain;
      DESCRIPTION = domain;
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
      ENABLE_PUSH_CREATE_USER = true;
      DEFAULT_PUSH_CREATE_PRIVATE = false;
      DISABLED_REPO_UNITS = builtins.concatStringsSep "," [
        "repo.issues"
        "repo.ext_issues"
        "repo.pulls"
        "repo.wiki"
        "repo.ext_wiki"
        "repo.projects"
        "repo.packages"
        "repo.actions"
      ];
      DISABLE_STARS = true;
      DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
    };
    "repository.upload".ENABLED = false;
    service.DISABLE_REGISTRATION = true;
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
in
{
  flake.modules.nixos.forgejo =
    { pkgs, config, ... }:
    {
      environment.persistence.nixos.directories = [ "/var/lib/forgejo" ];

      vms.forgejo = {
        environment.systemPackages = [ pkgs.forgejo ];
        environment.sessionVariables.FORGEJO_WORK_DIR = "/var/lib/forgejo";
        microvm.shares = [
          {
            source = "/var/lib/forgejo";
            mountPoint = "/var/lib/forgejo";
            tag = "forgejo";
            proto = "virtiofs";
          }
        ];

        boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 22;
        services.openssh.openFirewall = true;
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.openssh.ports = [ 2222 ];

        services.forgejo = {
          enable = true;
          package = pkgs.forgejo;
          inherit settings;
        };
      };
    };

  local.desktops.grancel.imports = [ self.modules.nixos.forgejo ];

  local.servers.crossbell.local.caddy.reverseProxies.${domain} =
    self.nixosConfigurations.grancel.config.microvm.vms.forgejo.config.config.networking.fqdn;
}
