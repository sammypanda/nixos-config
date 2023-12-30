{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, nix-vscode-extensions }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      vanilla = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./hosts/vanilla/configuration.nix
        ];
      };
    };
  };
}