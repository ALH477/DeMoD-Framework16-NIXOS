{
  description = "NixOS Configuration for Development with DeMoD Communication Framework";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate.url = "github:DeterminateSystems/determinate/0.1.0";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    fw-fanctrl.url = "github:TamtamHero/fw-fanctrl/packaging/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, determinate, nixos-hardware, fw-fanctrl, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit nixpkgs-unstable; };
      modules = [
        determinate.nixosModules.default
        (lib.optional (config.hardware.framework.enable or false) nixos-hardware.nixosModules.framework-16-7040-amd)
        (lib.optional (config.hardware.fw-fanctrl.enable or false) fw-fanctrl.nixosModules.default)
        ./hardware-configuration.nix
        ./configuration.nix
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.system;
                config.allowUnfree = true;
              };
            })
          ];
          options.hardware.framework.enable = lib.mkEnableOption "Framework 16-inch 7040 AMD support";
          options.hardware.fw-fanctrl.enable = lib.mkEnableOption "Framework fan control";
        }
      ];
    };
  };
}
