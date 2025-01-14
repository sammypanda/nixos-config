# Function to recurse through machines, generating nixosConfiguration objects
{ machines, nixpkgs, overlays, home-manager }: 

  builtins.listToAttrs (map (machine: {
    name = machine.name;
    value = nixpkgs.lib.nixosSystem {
      system = machine.arch;

      modules = [
        { nixpkgs.config.allowUnfree = true; }
        { nixpkgs.overlays = [ overlays.default ]; }
        ../machines/configurationDefault.nix
        ../machines/${machine.name}/configuration.nix
        ../machines/${machine.name}/configurationHardware.nix
        { networking.hostName = machine.name; }
      ];
    };
  }) machines)