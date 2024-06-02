{
  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager"; # unstable
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-vscode-extensions, nixos-cosmic, home-manager, suyu } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      overlays = [self.overlays.default];

      config = {
        allowUnfree = true;
      };
    };
  in {
    overlays.default = final: prev: {
      suyu = inputs.suyu.packages."${system}".suyu;
    };

    nixosConfigurations = {
      vanilla = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system pkgs; };

        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/vanilla/configuration.nix
        ];
      };
    };
  };
}
