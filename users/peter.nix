{
  users.users.peter = {
    uid = 1000;
    #password = "peter";
    isNormalUser = true;
    extraGroups = [ "wheel" "transmission" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILACfyJt7+ULfX1XFhBbztlTMNDZnRNQbKj5DV2S7uVo peter@grancel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQzVZRQGL+282Zk6pPBO2tni2iCRpCi8cNUMcNMpiuX peter@vps221009.vps.ovh.ca"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9oTGdaddqjAM93FQP83XABhVxZo1jo8ljb62CtUoBq peter@ruan"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR/4VIeWmdlbrR0lHNjwpZmr4+jqJ+CslwJfe+BjbKTOjelAiOnUjwQHZFyhQwwc56ZHfw438AHxwOzMBPZSMHQDtJG3F1tXjqErqjFjSz7axyFkxXcmdlTJKkTmRuM9KmkyNBdi9JAqoXnWJFH7kMxNM0WB125SSM0T4arvKd2BdAFVyE+LgAobbtXELQZFfncH88Jlbm1qyzYeiMXHRUJDd3z+0JmZrg5/3NniGWoVSkm+fVyuragxwAR+bHU0XEI6LwmljfNw91PqTDtRmhDN0rN93TjknonqxHTIftZbEnz2aK46s57eHAY7Wmy4dyy2ZSht2mChLDyRTHQWvF Created for price@hubspot.com by Kickstart"
    ];
  };
}
