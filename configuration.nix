{ config, pkgs, lib, nixpkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  options = {
    custom.steam.enable = lib.mkEnableOption "Steam and gaming support" // { default = false; };
  };

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = lib.optional config.hardware.framework.enable "amdgpu.abmlevel=0";

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.displayManager.defaultSession = "hyprland";
    services.xserver.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.unstable.hyprland;
    };

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
    powerManagement.cpuFreqGovernor = "performance";

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
    security.polkit.enable = true;
    services.power-profiles-daemon.enable = true;
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

    virtualisation.docker.enable = true;

    programs.wireshark.enable = true;

    users.users.asher = {
      isNormalUser = true;
      description = "Asher";
      extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "disk" ];
      shell = pkgs.bash;
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

    nixpkgs.config.allowUnfree = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    environment.systemPackages = with pkgs; [
      vim docker git git-lfs gh htop nvme-cli lm_sensors s-tui stress dmidecode util-linux gparted usbutils
      python3Full python3Packages.pip python3Packages.virtualenv python3Packages.cryptography python3Packages.pycryptodome
      python3Packages.grpcio python3Packages.grpcio-tools python3Packages.protobuf
      python3Packages.numpy python3Packages.matplotlib
      wireshark cmake ardour blueberry vesktop audacity font-awesome fastfetch gnugrep
      gcc gnumake ninja kitty wofi waybar pavucontrol hyprpaper rustc cargo go openssl gnutls qemu virt-manager
      ffmpeg jack2 qjackctl libpulseaudio pkgsi686Linux.libpulseaudio tcpdump nmap netcat docker-compose docker-buildx
      vulkan-tools vulkan-loader vulkan-validation-layers brave hyprland vlc pandoc kdePackages.okular xorg.xinit libva-utils obs-studio
      xfce.thunar xfce.thunar-volman gvfs udiskie polkit_gnome framework-tool brightnessctl
      gimp inkscape blender libreoffice krita protobufc grpc pkgconf
      wl-clipboard grim slurp
      mininet
      unstable.openvscode-server
      (perl.withPackages (ps: with ps; [ JSON GetoptLong CursesUI ModulePluggable Appcpanminus ]))
      (sbcl.withPackages (ps: with ps; [
        cffi cl-ppcre cl-json cl-csv usocket bordeaux-threads log4cl trivial-backtrace cl-store hunchensocket fiveam cl-dot cserial-port
      ]))
      libserialport
      can-utils
      lksctp-tools
      cjson
      ncurses
      libuuid
      kicad
      graphviz
      mako
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
