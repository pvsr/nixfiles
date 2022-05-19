let
  grancel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOu8H2biu/VfprPNHEf08br50+GfkPUU2+H8DgI7Ol3V";
  secrets = [
    "btrbk.id_ed25519.age"
  ];
in
builtins.listToAttrs (map secrets (name: {
  inherit name;
  value = { publicKeys = [ grancel ] }; }))
