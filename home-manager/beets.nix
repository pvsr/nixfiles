{
  programs.beets.enable = true;
  programs.beets.settings = {
    directory = "~/music";
    library = "~/.local/state/beets/library.db";
    plugins = [
      "random"
      "scrub"
      "ftintitle"
      "fetchart"
      "chroma"
    ];
    original_date = true;
    from_scratch = true;
    match.preferred = {
      countries = [
        "XW"
        "US"
        "JP"
      ];
      media = [
        "Digital Media|File"
        "CD"
      ];
      original_year = true;
    };
    scrub.auto = true;
  };
}
