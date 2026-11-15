{
  description = "Moja konfiguracja NixOS z Flakes";

  inputs = {
    # Pobieramy stabilne lub unstable repozytorium paczek (zostawiamy nixos-unstable lub wpisz wersję, np. nixos-25.05)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # UWAGA: Słowo "nixos" poniżej to nazwa Twojego hosta (networking.hostName).
      # Musi być dokładnie taka sama, jaką masz wpisaną w configuration.nix!
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
  };
}
