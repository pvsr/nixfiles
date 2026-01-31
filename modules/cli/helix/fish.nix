{
  flake.modules.hjem.desktop =
    { pkgs, ... }:
    {
      helix.languages = {
        language = [
          {
            name = "fish";
            language-servers = [ "fish-lsp" ];
          }

        ];
        language-server.fish-lsp = {
          command = "${pkgs.fish-lsp}/bin/fish-lsp";
          args = [ "start" ];
        };
      };
    };
}
