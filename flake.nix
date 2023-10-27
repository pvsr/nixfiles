{
  description = "A system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-23.05;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware;
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager/release-23.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.url = github:t184256/nix-on-droid;
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";

    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    podcasts.url = github:pvsr/podcasts;
    podcasts.inputs.nixpkgs.follows = "nixpkgs";
    podcasts.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    weather.url = github:pvsr/weather;
    weather.inputs.nixpkgs.follows = "nixpkgs";
    weather.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    qbpm.url = github:pvsr/qbpm;
    qbpm.inputs.nixpkgs.follows = "nixpkgs";
    qbpm.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

    # sources
    srcery-tmux.url = github:srcery-colors/srcery-tmux;
    srcery-tmux.flake = false;
    fish-prompt-pvsr.url = github:pvsr/fish-prompt-pvsr;
    fish-prompt-pvsr.flake = false;
  };

  outputs = inputs: let
    overlays = [(import ./overlay.nix inputs)];
    specialArgs.flake = {inherit inputs;};
    specialArgs.appFont = "Fantasque Sans Mono";
    extraSpecialArgs = specialArgs;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      flake.nixosConfigurations = builtins.mapAttrs (hostName: hostModule:
        inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            hostModule
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.age
            {
              nixpkgs = {
                inherit overlays;
                hostPlatform = "x86_64-linux";
              };
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.peter = import ./home-manager/${hostName}.nix;
              };
            }
            (import ./modules/nix.nix)
            (import ./modules/nixos.nix)
            (import ./users/peter.nix)
          ];
        }) (import ./hosts);

      flake.legacyPackages.aarch64-linux.nixOnDroidConfigurations.arseille = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs {
          overlays = [inputs.nix-on-droid.overlays.default] ++ overlays;
          system = "aarch64-linux";
        };
        system.stateVersion = "22.11";
        home-manager-path = inputs.home-manager.outPath;
        modules = [
          ./hosts/arseille
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraSpecialArgs;
            home-manager.config = import ./home-manager/arseille.nix;
          }
        ];
      };

      perSystem = {
        pkgs,
        system,
        self',
        inputs',
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system overlays;
        };
        legacyPackages.homeConfigurations.jurai = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = [./home-manager/macbook.nix];
        };

        formatter = pkgs.alejandra;
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.alejandra.enable = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;
          buildInputs = let
            deploy = host: user: (pkgs.writeScriptBin "deploy-${host}" ''
              nixos-rebuild --fast --flake .#${host} --target-host ${user}@${host} --use-remote-sudo switch
            '');
          in [
            inputs'.agenix.packages.agenix
            (deploy "ruan" "peter")
            (deploy "crossbell" "root")
          ];
        };
      };
    };
}
