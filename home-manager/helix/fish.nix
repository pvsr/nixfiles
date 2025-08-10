{
  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      programs.helix.languages = {
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
