{
  flake.modules.nixos.microvm-guest =
    { pkgs, config, ... }:
    let
      inherit (builtins)
        substring
        hashString
        concatStringsSep
        genList
        fromTOML
        ;
      generated =
        let
          minCid = 3;
          hash = hashString "sha256" config.networking.fqdn;
          getByte = i: substring (i * 2) 2 hash;
          getMacOctet = i: if i == 0 then "${substring 0 1 hash}2" else getByte i;
        in
        {
          macAddress = genList getMacOctet 6 |> concatStringsSep ":";
          cid = minCid + (fromTOML "rand = 0x${getByte 0}").rand;
        };
    in
    {
      microvm = {
        vsock.cid = generated.cid;
        vsock.ssh.enable = true;
        registerWithMachined = true;
        interfaces = [
          {
            type = "tap";
            id = substring 0 15 "vm-${config.networking.hostName}";
            mac = generated.macAddress;
          }
        ];
        shares = [
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            inherit (config.microvm) proto;
          }
        ];
      };

      nix.optimise.automatic = false;
      security.sudo.wheelNeedsPassword = false;
    };
}
