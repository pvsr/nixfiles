{
  flake.modules.hjem.core =
    { config, pkgs, ... }:
    {
      packages = [ pkgs.eza ];

      fish.interactiveShellInit = # fish
        ''
          function eza --wraps=eza
            command eza --git $argv
          end
          abbr -a e  'eza -l'
          abbr -a ea 'eza -la'
          abbr -a er 'eza -ls modified'
          abbr -a et 'eza -T'
          abbr -a ls 'eza'
          abbr -a l  'eza -l'
          abbr -a ll 'eza -l'
          abbr -a la 'eza -la'
        '';
    };
}
