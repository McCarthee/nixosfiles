{
   description = "Nixos config flake";

   inputs = {
      catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, ... }@inputs: {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs;};
         modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
            {
               nixpkgs.overlays = [
                  inputs.catppuccin-vsc.overlays.default
               ];
            }
         ];
      };
   };
}
