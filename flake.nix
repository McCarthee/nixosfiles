{
   description = "Nixos config flake";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
      catppuccin.url = "github:catppuccin/nix";

      nixvim = {
         url = "github:nix-community/nixvim";
         inputs.nixpkgs.follows = "nixpkgs";
      };
    
      home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, nixvim, catppuccin, ... }@inputs: {
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
