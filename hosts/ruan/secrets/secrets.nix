let
  ruan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi5+Pco0lVGVsAPRJl+FQd+c+AAsRHmZavWjaUgMsmO";
  secrets = [
    "radicale-users.age"
    "transmission-credentials.json.age"
    "miniflux-credentials.age"
    "nginx-podcasts.htpasswd.age"
  ];
in
builtins.listToAttrs (map
  (name: {
    inherit name;
    value = { publicKeys = [ ruan ]; };
  }
  )
  secrets
)
