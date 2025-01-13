# Function to recurse through machines, generating nixosConfiguration objects
{ machines, nixpkgs, overlays }: 

  builtins.listToAttrs (map (machine: {
    name = machine.name;
    value = nixpkgs.lib.nixosSystem {
      system = machine.arch;

      modules = [
        { nixpkgs.overlays = [ overlays.default ]; }
        ../machines/${machine.name}/configuration.nix
      ];
    };
  }) machines)