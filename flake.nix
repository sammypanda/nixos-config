{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-vscode-extensions, nixos-cosmic }:
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
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./hosts/vanilla/configuration.nix
        ];
      };
    };
  };
}
