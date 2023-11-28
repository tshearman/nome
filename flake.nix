# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.6)
{
  description = "Nome: my Nix home";

  inputs = {
    fh = { url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-checker = { url = "https://flakehub.com/f/DeterminateSystems/flake-checker/*.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";
    home-manager = { url = "https://flakehub.com/f/nix-community/home-manager/*.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-darwin = { url = "github:LnL7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nuenv = { url = "https://flakehub.com/f/DeterminateSystems/nuenv/*.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    uuidv7 = { url = "git+ssh://git@github.com/DeterminateSystems/uuidv7.git"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.self.overlays.default ];
        };
      });

      stateVersion = "23.11";
      system = "aarch64-darwin";
      username = "lucperkins";
    in
    {
      schemas = inputs.flake-schemas.schemas;

      devShells = forEachSupportedSystem ({ pkgs }: {
        default =
          let
            # This janky-ish script is necessary because nix-darwin isn't yet fully flake friendly
            reload = pkgs.writeScriptBin "reload" ''
              ${pkgs.nixFlakes}/bin/nix build .#darwinConfigurations.${pkgs.username}-${pkgs.system}.system
              ./result/sw/bin/darwin-rebuild switch --flake .
            '';
          in
          pkgs.mkShell {
            name = "nome";
            packages = with pkgs; [
              nixpkgs-fmt
              reload
            ];
          };
      });

      overlays.default = final: prev: {
        inherit username system;
        homeDirectory =
          if (prev.stdenv.isDarwin)
          then "/Users/${username}"
          else "/home/${username}";
        rev = inputs.self.rev or inputs.self.dirtyRev or null;
        flake-checker = inputs.flake-checker.packages.${system}.default;
        fh = inputs.fh.packages.${system}.default;
        uuidv7 = inputs.uuidv7.packages.${system}.default;
      };

      darwinConfigurations."${username}-${system}" = inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          inputs.self.darwinModules.base
          inputs.home-manager.darwinModules.home-manager
          inputs.self.darwinModules.home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: import ./nix-darwin/base {
          inherit pkgs;
          overlays = [
            inputs.nuenv.overlays.default
            inputs.self.overlays.default
          ];
        };

        home-manager = { pkgs, ... }: import ./nix-darwin/home-manager {
          inherit pkgs stateVersion username;
        };
      };

      templates = import
        ./templates;
    };
}
