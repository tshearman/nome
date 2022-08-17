{ homeDirectory
, pkgs
, stateVersion
, system
, username
}:

rec {
  # Fonts config
  fonts = { fontconfig = { enable = true; }; };

  # Basic Home Manager config
  home = { inherit homeDirectory packages stateVersion; };

  # Configure Nix itself (using an unstable version)
  nix = import ./nix.nix { nix = pkgs.nixUnstable; };

  # Nixpkgs config
  nixpkgs = import ./nixpkgs;

  # The packages to load into the PATH
  packages = import ./packages.nix { inherit homeDirectory pkgs; };

  # Configurations for programs directly supported by Home Manager
  programs = import ./programs.nix { inherit homeDirectory pkgs; };
}
