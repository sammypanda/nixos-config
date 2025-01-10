{
  description = "System flake";

  inputs = {
    pkgs-24_05.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-24.11";
    unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
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

    nook-desktop = {
      url = "github:sammypanda/nixos-nook-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { 
    self, 
    pkgs-24_05,
    nixpkgs,
    unstable,
    nix-vscode-extensions, 
    nixos-cosmic, 
    home-manager, 
    suyu, 
    nook-desktop, 
    nix-gaming 
  } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      overlays = [self.overlays.default];

      config = {
        allowUnfree = true;
        
        # Allow EOL packages
        permittedInsecurePackages = [
          "electron-25.9.0"
          "electron-24.8.6"
          "electron-27.3.11"
        ];
      };
    };
  in {
    overlays.default = final: prev: {
      suyu = inputs.suyu.packages."${system}".suyu;
      nook-desktop = inputs.nook-desktop.packages."${system}".default;
      nix-gaming = inputs.nix-gaming.packages."${system}";
      extensions = inputs.nix-vscode-extensions.extensions.${system};
    };

    nixosConfigurations = {
      vanilla = nixpkgs.lib.nixosSystem {
        specialArgs = { 
          inherit system pkgs;
          pkgs-unstable = import unstable {};
          pkgs-24_05 = import pkgs-24_05 {};
        };

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
