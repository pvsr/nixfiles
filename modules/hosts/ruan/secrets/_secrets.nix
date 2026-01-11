builtins.listToAttrs (
  map
    (name: {
      inherit name;
      value.publicKeys = [
        # host key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi5+Pco0lVGVsAPRJl+FQd+c+AAsRHmZavWjaUgMsmO"
        # peter@grancel
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo"
      ];
    })
    [
      "radicale-users.age"
      "transmission-credentials.json.age"
      "miniflux-credentials.age"
      "dns-token.age"
    ]
)
