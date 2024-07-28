{
  # A simple description of this Flake.
  description = "Nixcfg";

  inputs = {
    # Nixpkgs Channel Branches
    # ref: https://nix.dev/concepts/faq#which-channel-branch-should-i-use
    #
    # For stable Nixpkgs on Linux (including NixOS and WSL), use "github:nixos/nixpkgs/nixos-${version}".
    # For rolling Nixpkgs on Linux (including NixOS and WSL), use "github:nixos/nixpkgs/nixos-unstable".
    # For stable Nixpkgs on macOS, use "github:nixos/nixpkgs/nixos-${version}-darwin".
    # For rolling Nixpkgs on any platform, use "github:nixos/nixpkgs/nixpkgs-unstable".
    #
    # If this repo contains both macOS and Linux systems, stick with the last option, since there is no way
    # currently to define separate Nixpkgs instances per host, yet.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Snowfall Lib makes it easy to manage your Nix flake by imposing an opinionated file structure.
    # ref: https://snowfall.org/guides/lib/quickstart/
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix enables secure management and deployment of secrets using SSH keys.
    # ref: https://github.com/ryantm/agenix
    #
    # Ragenix is a drop-in reimplementation of Agenix, written in Rust.
    # ref: https://github.com/yaxitech/ragenix
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware is a collection of NixOS modules covering hardware quirks.
    # ref: https://github.com/NixOS/nixos-hardware
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      # `inputs.nixpkgs.follows` is unnecessary here because this flake doesn't have an input for it.
    };

    # Impermanence helps you handle persistent state on systems with ephemeral root storage.
    # ref: https://github.com/nix-community/impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
      # `inputs.nixpkgs.follows` is unnecessary here because this flake doesn't have an input for it.
    };

    # Home Manager allows for declarative configuration of user specific (non-global) packages and dotfiles.
    # ref: https://github.com/nix-community/home-manager
    #
    # Note that this input must be named `home-manager` for Snowfall Lib to recognize it.
    # ref: https://snowfall.org/reference/lib/#home-manager
    #
    # Use "github:nix-community/home-manager/release-${version}" if using the Nixpkgs stable channel.
    # Use "github:nix-community/home-manager" if using the Nixpkgs unstable channel.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin allows you to configure macOS like it is NixOS.
    # ref: http://daiderd.com/nix-darwin/
    #
    # Note that this input must be named `darwin` for Snowfall Lib to recognize it.
    # ref: https://snowfall.org/reference/lib/#darwin-and-nixos-generators
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Generators allows you to take a NixOS configuration and output to a variety of image formats.
    # ref: https://github.com/nix-community/nixos-generators
    #
    # Note that this input must be named `nixos-generators` for Snowfall Lib to recognize it.
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko allows for declarative partitioning of a NixOS system.
    # ref: https://github.com/nix-community/disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Index Database is a weekly updated database of Nix packages that you can use to quickly locate nix packages
    # with specific files.
    # ref: https://github.com/nix-community/nix-index-database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake is a simplified Nix Flakes CLI application.
    # ref: https://github.com/snowfallorg/flake
    snowfall-flake = {
			url = "github:snowfallorg/flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    # Snow is a simplified Nix Package Manager CLI application.
    # ref: https://github.com/snowfallorg/snow/tree/main
    snow = {
			url = "github:snowfallorg/snow";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    # NixOS Conf Editor is an application that allows you to view and edit your NixOS configuration graphically.
    # ref: https://github.com/snowfallorg/nixos-conf-editor
    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Software Center allows you to browse and download Nix applications graphically.
    # ref: https://github.com/snowfallorg/nix-software-center
    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Flatpak is a declarative flatpak manager for NixOS.
    # ref: https://github.com/gmodena/nix-flatpak
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
      # `inputs.nixpkgs.follows` is unnecessary here because this flake doesn't have an input for it.
    };

    # Lanzaboote enables Secure Boot for NixOS.
    # ref: https://github.com/nix-community/lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;

    snowfall = {
      # ref: https://snowfall.org/reference/lib/#snowfall-configuration

      # Tell Snowfall Lib to look in the current directory for your Nix files.
      root = ./.;

      # Choose a namespace to use for your flake's packages, libraries, and overlays.
      namespace = "internal";

      # Add flake metadata that can be processed by tools like Snowfall Frost.
      meta = {
          # A slug to use in documentation when displaying things like file paths.
          name = "nixcfg";

          # A title to show for your flake, typically the name.
          title = "Nixcfg";
      };
    };

    channels-config = {
      # ref: https://snowfall.org/guides/lib/channels

      # Allow Nix to build and install non-FOSS packages.
      allowUnfree = true;

      # Override listed insecure packages, allowing them to be installed regardless of their vulnerabilities.
      permittedInsecurePackages = [];

      # Additional configuration for specific packages.
      config = {};
    };

    # Overlays allow you to globally modify derivations in the default nixpkgs instance.
    # ref: https://nixos-and-flakes.thiscute.world/nixpkgs/overlays
    overlays = with inputs; [
      snowfall-flake.overlays.default
    ];

    systems = {
      # ref: https://snowfall.org/guides/lib/systems/

      # Modules allow you to split your configuration into multiple files,
      # and exposes the ability to modify that configuration in a way that
      # importing alone simply cannot provide.
      # ref: https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/module-system

      # Modules to add for all NixOS systems.
      modules.nixos = with inputs; [
        agenix.nixosModules.default
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        nix-flatpak.nixosModules.nix-flatpak
        lanzaboote.nixosModules.lanzaboote
      ];

      # Modules to add for all macOS systems.
      modules.darwin = with inputs; [];

      # Modules to add for the specific system `framework-16`.
      hosts.framework-16.modules = with inputs; [
        nixos-hardware.nixosModules.framework-16-7040-amd
      ];

      # Additional arguments to add for the specific host `my-host`.
      # hosts.my-host.specialArgs = {
      #   my-custom-value = "my-value";
      # };
    };

    homes = {
      # ref: https://snowfall.org/guides/lib/homes

      # Modules to add for all homes.
      modules = with inputs; [
        impermanence.nixosModules.home-manager.impermanence
        nix-index-database.hmModules.nix-index
      ];

      # Modules to add for the specific home `my-user@my-host`.
      # users."my-user@my-host".modules = with inputs; [
      #   my-input.homeModules.my-module
      # ];

      # Additional arguments to add for the specific home `my-user@my-host`.
      # homes.users."my-user@my-host".specialArgs = {
      #   my-custom-value = "my-value";
      # };
    };

    # Aliases are used to define additional exports with different names.
    # ref: https://snowfall.org/guides/lib/alias/
    alias = {
      # packages.default = "my-package";
      shells.default = "bootstrap";
      # overlays.default = "my-overlay";
      # templates.default = "my-template";
      # modules.nixos.default = "my-nixos-module";
      # modules.darwin.default = "my-nixos-module";
      # modules.home.default = "my-nixos-module";
    };
  };
}
