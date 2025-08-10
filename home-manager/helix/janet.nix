{
  flake.modules.homeManager.core.programs.helix.languages = {
    language = [
      {
        name = "janet";
        auto-format = true;
        language-servers = [ "janet-lsp" ];
      }
    ];
    language-server.janet-lsp = {
      command = "janet-lsp";
    };
  };
}
