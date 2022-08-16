{
  users.users.peter = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "transmission"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9oTGdaddqjAM93FQP83XABhVxZo1jo8ljb62CtUoBq"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgVQjYQ3EKuiXE3b7wn8vADTTMO/Jm7Vf+PRzgkTkG/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBMswv0obMNyU9xAYGAxOD/Z0jYemfEONN0u+xeYmUM"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR/4VIeWmdlbrR0lHNjwpZmr4+jqJ+CslwJfe+BjbKTOjelAiOnUjwQHZFyhQwwc56ZHfw438AHxwOzMBPZSMHQDtJG3F1tXjqErqjFjSz7axyFkxXcmdlTJKkTmRuM9KmkyNBdi9JAqoXnWJFH7kMxNM0WB125SSM0T4arvKd2BdAFVyE+LgAobbtXELQZFfncH88Jlbm1qyzYeiMXHRUJDd3z+0JmZrg5/3NniGWoVSkm+fVyuragxwAR+bHU0XEI6LwmljfNw91PqTDtRmhDN0rN93TjknonqxHTIftZbEnz2aK46s57eHAY7Wmy4dyy2ZSht2mChLDyRTHQWvF"
    ];
  };
}
