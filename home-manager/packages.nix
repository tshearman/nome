{ pkgs }:

let
  basic = with pkgs; [
    coreutils
    findutils
    tree
    unzip
    wget
    zstd
  ];

  bin = import ./bin.nix {
    inherit pkgs;
  };

  buildTools = with pkgs; [
    cmake
  ];

  databaseTools = with pkgs; [
    postgresql_14
    redis
  ];

  devOpsTools = with pkgs; [
    awscli2
    dive
    flyctl
    kubectl
    minikube
  ];

  gitTools = (with pkgs; [
    difftastic
    git-crypt
  ] ++ (with gitAndTools; [
    diff-so-fancy
    git-codeowners
    gitflow
  ]));

  jsTools = (with pkgs; [
    biome
    bun
    deno
  ] ++ (with nodePackages; [
    pnpm
  ]));

  macTools = with pkgs.darwin.apple_sdk.frameworks; [
    CoreServices
    Foundation
    Security
  ];

  misc = with pkgs; [
    comma
    elixir
    elixir-ls
    lima
    mprocs
    neofetch
    ngrok
    process-compose
    protobuf
    reattach-to-user-namespace # for tmux
    vector
    yt-dlp
  ];

  nixTools = with pkgs; [
    nixfmt-classic
    nixpkgs-fmt
  ];

  pythonTools = with pkgs; [ python311 ] ++ (with pkgs.python311Packages; [
    httpie
  ]);

  rustTools = with pkgs; [
    bacon
    cargo-edit
    cargo-machete
    cargo-watch
    rust-analyzer
  ];

  scripts = with pkgs; [
    (writeScriptBin "pk" ''
      if [ $# -eq 0 ]; then
        echo "No process name supplied"
      fi

      for proc in $1; do
        pgrep -f $proc | xargs kill -9
      done
    '')
  ];

  security = with pkgs; [
    certstrap
    cosign
    grype
    pinentry_mac
    syft
  ];

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [
    materialize
  ];
in
pkgs.extraPkgs
++ basic
++ bin
++ buildTools
++ databaseTools
++ devOpsTools
++ gitTools
++ jsTools
++ macTools
++ misc
++ nixTools
++ pythonTools
++ rustTools
++ scripts
++ security
