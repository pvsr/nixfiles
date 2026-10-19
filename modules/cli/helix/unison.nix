{
  flake.modules.hjem.core.helix.languages = {
    language = [
      {
        name = "unison";
        language-servers = [ "ucm" ];
      }
    ];
    language-server.ucm = {
      command = "nc";
      args = [
        "localhost"
        "5757"
      ];
    };
  };
}
