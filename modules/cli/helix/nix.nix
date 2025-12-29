{
  flake.modules.hjem.core.helix.languages.language = [
    {
      name = "nix";
      formatter.command = "nixfmt";
      auto-format = true;
    }
  ];
}
