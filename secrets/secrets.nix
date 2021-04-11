let
  ruan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi5+Pco0lVGVsAPRJl+FQd+c+AAsRHmZavWjaUgMsmO";
in
{
  "radicale-users.age".publicKeys = [ ruan ];
  "transmission-credentials.json.age".publicKeys = [ ruan ];
  "miniflux-credentials.age".publicKeys = [ ruan ];
}
