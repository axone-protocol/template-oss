{
  description = "Axone opensource template development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Minimal shell: this repo is a language-agnostic template, so it only
          # ships the tools needed to run the lints already configured here
          # (see .markdownlint.yaml, .yamllint.yaml, .codespellrc). Downstream
          # projects generated from this template are expected to extend this
          # shell with their own stack-specific tooling.
          default = pkgs.mkShell {
            packages = [
              pkgs.codespell
              pkgs.git
              pkgs.markdownlint-cli2
              pkgs.yamllint
            ];

            shellHook = ''
              echo "Axone template-oss development environment loaded"
            '';
          };
        }
      );
    };
}
