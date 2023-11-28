{
  description = "Luis's NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Add Alejandra
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    # Add AGS
    ags.url = "github:Aylur/ags";

    # Add Nix-color
    nix-colors.url = "github:misterio77/nix-colors";

    # Nix Software Center
    nix-software-center.url = "github:vlinkz/nix-software-center";

    # NixOS Configuration Editor
    nix-conf-editor.url = "github:vlinkz/nixos-conf-editor";

    # Spicetify
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    alejandra,
    nix-conf-editor,
    nix-software-center,
    self,
    nixpkgs,
    spicetify-nix,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # Run the following command in the flake's directory to
      # deploy this configuration on any NixOS system:
      #   sudo nixos-rebuild switch --flake .#thinkpad
      "thinkpad" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.luis = import ./home-manager/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
