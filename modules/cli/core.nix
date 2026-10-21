{
  flake.modules.hjem.core =
    { lib, pkgs, ... }:
    {
      packages = with pkgs; [
        fd
        nh
        dix
        nil
        nix-output-monitor
        duf
        dust
        bottom
        zoxide
        (ranger.override {
          imagePreviewSupport = false;
          sixelPreviewSupport = false;
        })

        # from https://kokada.dev/blog/quick-bits-realise-nix-symlinks/
        (writeShellApplication {
          name = "realize";
          runtimeInputs = [ coreutils ];
          text = ''
            for file in "$@"; do
              if [[ -L "$file" ]]; then
                if [[ -d "$file" ]]; then
                  tmpdir="''${file}.tmp"
                  mkdir -p "$tmpdir"
                  cp --verbose --recursive "$file"/* "$tmpdir"
                  unlink "$file"
                  mv "$tmpdir" "$file"
                  chmod --changes --recursive +w "$file"
                else
                  cp --verbose --remove-destination "$(readlink "$file")" "$file"
                  chmod --changes +w "$file"
                fi
              else
                >&2 echo "Not a symlink: $file"
                exit 1
              fi
            done
          '';
        })
      ];
    };
}
