let
  ruan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi5+Pco0lVGVsAPRJl+FQd+c+AAsRHmZavWjaUgMsmO";
  grancel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOu8H2biu/VfprPNHEf08br50+GfkPUU2+H8DgI7Ol3V";
in
{
  "radicale-users.age".publicKeys = [ ruan ];
  "transmission-credentials.json.age".publicKeys = [ ruan ];
  "miniflux-credentials.age".publicKeys = [ ruan ];
  "nginx-podcasts.htpasswd.age".publicKeys = [ ruan ];
  "btrbk.id_ed25519.age".publicKeys = [ grancel ];
}
