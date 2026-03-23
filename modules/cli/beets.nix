{
  flake.modules.hjem.ruan =
    { pkgs, ... }:
    {
      packages = [ pkgs.beets ];
      xdg.config.files."beets/config.yaml".text = ''
        directory: "~/music"
        library: "~/.local/state/beets/library.db"
        plugins: [
          "random",
          "scrub",
          "ftintitle",
          "fetchart",
          "chroma",
        ]
        original_date: yes
        from_scratch: yes
        match:
          preferred:
            countries: [ "XW", "US", "JP" ]
            media: [ "Digital Media|File", "CD" ]
            original_year: yes
        scrub:
          auto: yes
      '';
    };
}
