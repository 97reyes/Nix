# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.

  # Use the systemd-boot EFI boot loader.
  # # boot = {
  # #   kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # #   loader = {
  # #     systemd-boot = {enable = true;};
  # #     grub = {useOSProber = true;};
  # #     efi = {
  # #       canTouchEfiVariables = true;
  # #       efiSysMountPoint = "/boot/efi";
  # #     };
  # #   };
  # #   kernelParams = ["acpi_backlight"];
  # #   initrd = {kernelModules = ["amdgpu"];};
  # #   supportedFilesystems = ["ntfs" "fat32" "ext4" "exfat" "btrfs"];
  # # };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 25;
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelParams = ["acpi_backlight"];
    initrd = {kernelModules = ["amdgpu"];};
    supportedFilesystems = ["ntfs" "fat32" "ext4" "exfat" "btrfs"];
  };

  # Network config
  networking.hostName = "luis"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  #networking.interfaces.enp1s0.useDHCP = true;
  #networking.interfaces.wlp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CO.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "la-latin1";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    layout = "latam";
    libinput = {
      # Enable touchpad support (enabled default in most desktopManager).
      enable = true;
      mouse.tapping = true;
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager = {
      bspwm.enable = true;
      awesome.enable = true;
      berry.enable = true;
      fluxbox.enable = true;
      openbox.enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [pkgs.epson_201207w pkgs.epson-201401w pkgs.gutenprint];
  };
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luis = {
    isNormalUser = true;
    description = "Luis";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # enable flatpak:
  services.flatpak.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # environment.sessionVariables = {
  #   NIX_GSETTINGS_OVERRIDES_DIR = lib.mkForce "${pkgs.budgie.override {gnome = null;}}/share/gsettings-schemas/${pkgs.budgie.name}/glib-2.0/schemas";
  # };

  # Fonts

  fonts.packages = with pkgs; [
    pkgs.iosevka
    pkgs.jost
    (nerdfonts.override {fonts = ["Iosevka" "Agave" "CascadiaCode" "JetBrainsMono"];})
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # alejandra.defaultPackage.${system}
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #inputs.nix-software-center.packages.${system}.nix-software-center
    #inputs.nix-software-center.packages.${system}.nix-software-center
    pkgs.git

    pkgs.alejandra
    pkgs.bun
    pkgs.nodePackages.prettier
    pkgs.biome
    pkgs.feh
    pkgs.yambar
    pkgs.yabar
    pkgs.wget
    pkgs.wezterm
    pkgs.vscode
    pkgs.vscodium
    pkgs.google-chrome
    pkgs.brave
    pkgs.firefox-devedition-unwrapped
    pkgs.adw-gtk3
    pkgs.gradience
    pkgs.setzer
    pkgs.fzf-zsh
    pkgs.fzf
    pkgs.plank
    pkgs.bat
    pkgs.eza
    pkgs.avizo

    pkgs.pywal
    pkgs.sxhkd
    pkgs.alacritty
    pkgs.neofetch
    pkgs.bunnyfetch
    pkgs.afetch
    pkgs.bfetch
    pkgs.macchina
    pkgs.dunst
    pkgs.eww
    pkgs.eww-wayland
    pkgs.avizo
    pkgs.swww
    pkgs.swaybg
    pkgs.waypaper
    pkgs.hyprshade
    pkgs.fet-sh
    pkgs.xdg-desktop-portal-hyprland
    pkgs.hyprnome
    pkgs.nwg-dock-hyprland
    pkgs.rofi-wayland
    pkgs.rofi
    pkgs.wofi
    pkgs.picom
    pkgs.kitty
    pkgs.texstudio
    pkgs.texlab
    pkgs.synapse
    pkgs.ulauncher
    pkgs.findex
    pkgs.virt-manager
    pkgs.gnome.gnome-tweaks
    pkgs.gedit
    pkgs.cinnamon.nemo-with-extensions
    pkgs.tectonic
    pkgs.lite-xl
    pkgs.lapce
    pkgs.typora
    pkgs.cloudflare-warp
    pkgs.cloudflare-dyndns
    pkgs.gnomeExtensions.cloudflare-warp-toggle
    pkgs.gnome-extension-manager
    xorg.xbacklight

    pkgs.openbox-menu
    pkgs.obconf
    pkgs.jgmenu
    pkgs.fluxboxlauncher
    pkgs.fbmenugen
    pkgs.tint2
    pkgs.xmenu
    pkgs._9menu
    pkgs.xdgmenumaker
    pkgs.menumaker
    pkgs.geany
    pkgs.fwupd
  ];

  programs.light.enable = true;
  programs.adb.enable = true;
  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  programs.river.enable = true;
  xdg.portal.wlr.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 4d";
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      allowed-users = ["luis"];
      substituters = [
        "https://cache.nixos.org"
      ];
      extra-substituters = [
        # Nix community's cache server
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        #"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
