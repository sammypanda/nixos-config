{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
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