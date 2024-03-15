{
  description = "My website, but in gleam!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
        devShells.x86_64-linux.default = 
          pkgs.mkShell {
            buildInputs = with pkgs; [
              fish
              just
              entr
              zellij
              erlang
              gleam
              rebar3
              hex
              podman
              lua
            ];
            shellHook = ''
              SHELL=fish exec fish -li
            '';
         };
    };

}
