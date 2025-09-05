{ config, pkgs, lib, nixpkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  options = {
    custom.steam.enable = lib.mkEnableOption "Steam and gaming support";
  };

  config = {
    nixpkgs.overlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      })
    ];

    nixpkgs.config.allowUnfree = true;

    custom.steam.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [ "amdgpu.abmlevel=0" ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.displayManager.defaultSession = "hyprland";
    services.xserver.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;
    services.xserver.windowManager.dwm.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.unstable.hyprland;
    };
    systemd.defaultUnit = lib.mkForce "graphical.target";

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.enableRedistributableFirmware = true;
    powerManagement.cpuFreqGovernor = "performance"; # Default governor, overridden by power-profiles-daemon

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    services.libinput.enable = true;
    services.acpid.enable = true;
    services.printing.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig = {
        pipewire."90-custom" = {
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 2048;
        };
      };
    };

    services.udisks2.enable = true;
    services.gvfs.enable = true;
    security.polkit.enable = true;
    services.power-profiles-daemon.enable = true; # Enables powerprofilesctl for terminal-based power mode switching
    services.fwupd.enable = true;
    environment.etc."fwupd/fwupd.conf".text = lib.mkForce ''
      [fwupd]
      UpdateOnBoot=true
    '';

    services.fprintd.enable = true;
    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
    };

    virtualisation.docker.enable = true; # Socket-activated, doesn't run at boot

    programs.wireshark.enable = true;

    users.users.asher = {
      isNormalUser = true;
      description = "Asher";
      extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "disk" ];
      shell = pkgs.bash;
      packages = with pkgs; [
        (writeShellScriptBin "install-quicklisp" ''
          curl -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp
          ${pkgs.sbcl}/bin/sbcl --load /tmp/quicklisp.lisp --eval '(quicklisp-quickstart:install)' --quit
        '')
      ];
    };

    systemd.user.services.quicklisp-install = {
      description = "Install Quicklisp for D-LISP";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScriptBin "install-quicklisp" ''
          curl -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp
          ${pkgs.sbcl}/bin/sbcl --load /tmp/quicklisp.lisp --eval '(quicklisp-quickstart:install)' --quit
        ''}/bin/install-quicklisp";
      };
      wantedBy = [ "default.target" ];
    };

    systemd.timers.nix-gc-generations = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };

    systemd.services.nix-gc-generations = {
      script = ''
        generations_to_delete=$(${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --list-generations | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.coreutils}/bin/head -n -5 | ${pkgs.coreutils}/bin/tr '\n' ' ')
        if [ -n "$generations_to_delete" ]; then
          ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations $generations_to_delete
        fi
        ${pkgs.nix}/bin/nix-collect-garbage
      '';
      serviceConfig.Type = "oneshot";
    };

    environment.systemPackages = with pkgs; [
      # Core tools
      vim docker git git-lfs gh htop nvme-cli lm_sensors s-tui stress dmidecode util-linux gparted usbutils
      # Python and libs
      python3Full python3Packages.pip python3Packages.virtualenv python3Packages.cryptography python3Packages.pycryptodome
      python3Packages.grpcio python3Packages.grpcio-tools python3Packages.protobuf
      python3Packages.numpy python3Packages.matplotlib
      # Networking and security
      wireshark tcpdump nmap netcat
      # Build and dev tools
      cmake gcc gnumake ninja rustc cargo go openssl gnutls pkgconf
      # Multimedia and audio
      ardour audacity ffmpeg jack2 qjackctl libpulseaudio pkgsi686Linux.libpulseaudio pavucontrol
      # Virtualization and emulation
      qemu virt-manager docker-compose docker-buildx
      # Vulkan and graphics tools
      vulkan-tools vulkan-loader vulkan-validation-layers libva-utils
      # Browsers and apps
      brave vlc pandoc kdePackages.okular obs-studio firefox thunderbird
      # Desktop utilities
      blueberry vesktop font-awesome fastfetch gnugrep kitty wofi waybar hyprpaper brightnessctl zip unzip
      # Creative tools
      gimp inkscape blender libreoffice krita
      # File management
      xfce.thunar xfce.thunar-volman gvfs udiskie polkit_gnome framework-tool
      # Screen capture and clipboard
      wl-clipboard grim slurp
      # Networking simulation
      mininet
      # Editors and servers
      unstable.openvscode-server
      # Language-specific packages
      (perl.withPackages (ps: with ps; [ JSON GetoptLong CursesUI ModulePluggable Appcpanminus ]))
      (sbcl.withPackages (ps: with ps; [
        cffi cl-ppcre cl-json cl-csv usocket bordeaux-threads log4cl trivial-backtrace cl-store hunchensocket fiveam cl-dot cserial-port
      ]))
      # Hardware and protocol libs
      libserialport can-utils lksctp-tools cjson ncurses libuuid kicad graphviz mako
      # Xorg fallback
      xorg.xinit
      # USB flashing tools
      unetbootin
      popsicle
      gnome-disk-utility
    ] ++ lib.optionals config.custom.steam.enable [
      steam
      steam-run
      linuxConsoleTools
      lutris
      wineWowPackages.stable
    ];

    programs.steam = lib.mkIf config.custom.steam.enable {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    hardware.steam-hardware = lib.mkIf config.custom.steam.enable {
      enable = true;
    };

    programs.gamemode = lib.mkIf config.custom.steam.enable {
      enable = true;
    };

    environment.etc."jack/conf.xml".text = ''
      <?xml version="1.0"?>
      <jack>
        <engine>
          <param name="driver" value="alsa"/>
          <param name="realtime" value="true"/>
        </engine>
      </jack>
    '';

    environment.etc."hypr/hyprland.conf".text = ''
      monitor=,preferred,auto,1
      exec-once=waybar
      exec-once=hyprpaper
      exec-once=mako &
      exec-once=udiskie &
      exec-once=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      bind=SUPER,Return,exec,kitty
      bind=SUPER,Q,killactive
      bind=SUPER,M,exit
      bind=SUPER,E,exec,thunar
      bind=SUPER,Space,exec,wofi --show drun
    '';

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    system.stateVersion = "25.05";
  };
}
