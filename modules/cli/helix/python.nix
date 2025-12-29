{
  flake.modules.hjem.core.helix.languages = {
    language = [
      {
        name = "python";
        auto-format = true;
        language-servers = [
          "ruff"
          "pylsp"
          "ty"
        ];
      }
    ];
    language-server.ty = {
      command = "ty";
      args = [ "server" ];
    };
  };
}
