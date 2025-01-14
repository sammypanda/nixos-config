# Function to recurse through machines, generating nixosConfiguration objects
{ machines, nixpkgs, overlays, home-manager }: 

  builtins.listToAttrs (map (machine: {
    name = machine.name;
    value = nixpkgs.lib.nixosSystem {
      system = machine.arch;

      modules = [
        # Configure nixpkgs
        { 
          nixpkgs.config = {
            # Allow unfree stuff :(
            allowUnfree = true; 

            # Allow some deprecated packages
            permittedInsecurePackages = [
              "electron-27.3.11"
            ];
          };
        }

        # Apply overlays and add extra packages
        { nixpkgs.overlays = [ overlays.default ]; }

        # Load machines
        ../machines/configurationDefault.nix
        ../machines/${machine.name}/configuration.nix
        ../machines/${machine.name}/configurationHardware.nix
        { networking.hostName = machine.name; }
      ];
    };
  }) machines)