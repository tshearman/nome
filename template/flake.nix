{
  description = "Local dev environment";

  inputs = {
    nome.url = "github:the-nix-way/nome";
  };

  outputs = { self, nome, ... }:
    nome.lib.dev.mkEnv (with nome.lib.dev.tools; go ++ node ++ protobuf);
}
