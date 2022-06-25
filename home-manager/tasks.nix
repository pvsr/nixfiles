{pkgs, ...}: {
  home.packages = with pkgs; [
    todoman
    vdirsyncer
  ];

  xdg.configFile."vdirsyncer/config".text = ''
    [general]
    status_path = "~/.local/share/vdirsyncer/status/"

    [pair cal]
    a = "local"
    b = "peterrice_xyz"
    collections = ["from b"]
    metadata = ["color", "displayname"]

    [storage local]
    type = "filesystem"
    path = "~/.calendars/"
    fileext = ".ics"

    [storage peterrice_xyz]
    type = "caldav"
    url = "https://calendar.peterrice.xyz"
    username = "peter"
    password.fetch = ["command", "pass", "show", "calendar.peterrice.xyz"]
  '';

  xdg.configFile."todoman/config.py".text = ''
    path = "~/.calendars/*"
    default_list = "work"
    default_due = 0
    humanize = True
  '';
}
