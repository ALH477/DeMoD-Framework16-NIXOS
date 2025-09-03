{
  description = "Determinate NixOS Setup for R&D with Multiple Kernels, Desktops, and DeMoD Communication Framework";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05"; # Pinned to commit for reproducibility; check for updates.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    fw-fanctrl.url = "github:TamtamHero/fw-fanctrl/packaging/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, determinate, nixos-hardware, fw-fanctrl, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit nixpkgs-unstable lib; };
      modules = [
        determinate.nixosModules.default
        ({ config, ... }: {
          imports = lib.optional config.hardware.framework.enable nixos-hardware.nixosModules.framework-16-7040-amd
                   ++ lib.optional config.services.fw-fanctrl.enable fw-fanctrl.nixosModules.default; # Used services.* for standard naming; adjust if module differs.
        })
        ./hardware-configuration.nix
        ./configuration.nix
        ({ config, lib, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.system;
                config.allowUnfree = true;
              };
            })
          ];
          options = {
            hardware.framework.enable = lib.mkEnableOption "Framework 16-inch 7040 AMD support" // { default = true; };
            services.fw-fanctrl.enable = lib.mkEnableOption "Framework fan control" // { default = true; };
          };
        })
      ];
    };
  };
}
