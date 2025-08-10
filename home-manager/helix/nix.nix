{
  flake.modules.homeManager.core.programs.helix.languages.language = [
    {
      name = "nix";
      formatter.command = "nixfmt";
      auto-format = true;
    }
  ];
}
