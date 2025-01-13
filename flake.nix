{
  # A string describing the flake.
  description = "Sammy NixOS Configurations";

  # Attribute set of values which reflect the values given to nix.conf. 
  # This can extend the normal behavior of a user's nix experience by adding flake-specific configuration, such as a binary cache.
  nixConfig = {
    extra-substituters = [ 
      "https://cosmic.cachix.org/" 
    ];

    extra-trusted-public-keys = [ 
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" 
    ];
  };

  # An attribute set of all the dependencies of the flake.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # COMMUNITY: Switch emulator package
    suyu.url = "git+https://git.suyu.dev/suyu/nix-flake";

    # COMMUNITY: Animal crossing background music package
    nook-desktop.url = "github:sammypanda/nixos-nook-desktop";

    # COMMUNITY: Minecraft world generator from real-world geospatial data
    arnis.url = "github:sammypanda/nixos-arnis";

    # COMMUNITY: Lots of useful stuff for gaming on linux ^_^
    nix-gaming.url = "github:fufexan/nix-gaming";

    # COMMUNITY: Extra vscode extensions!
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  # A function of one argument that takes an attribute set of all the realized inputs, and outputs another attribute set.
  outputs = { self, nixpkgs, ... } @ inputs:
  let
    # Overlays are Nix functions which accept ``final`` (after) and ``prev`` (before), 
    # and return a set of packages.
    overlays.default = final: prev: {
      # [Name of the package] = [Path to the flake for the package]
      suyu = inputs.suyu.packages."${prev.system}".suyu;
      arnis = inputs.arnis.packages."${prev.system}".default;
      nook-desktop = inputs.nook-desktop.packages."${prev.system}".default;
      nix-gaming = inputs.nix-gaming.packages."${prev.system}";
      extensions = inputs.nix-vscode-extensions.extensions.${prev.system};
    };

    # Define the list of machines to recurse
    machines = [
      { name = "vanilla"; arch = "x86_64-linux"; }
    ];
  in {
    # Generate configurations for every machine
    nixosConfigurations = import ./helpers/genConfigurations.nix { inherit machines nixpkgs overlays; };
  };
}