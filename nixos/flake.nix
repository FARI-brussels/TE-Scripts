{
  description = "Preconfigured FARI Demo NixOS ISO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };

  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages.x86_64-linux.fari-nix =
      nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "install-iso";

        # Point directly to nixpkgs
        nixpkgs = nixpkgs;

        modules = [ ./configuration.nix ./hardware-configuration.nix ];
      };
  };
}
