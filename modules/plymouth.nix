{ config, lib, pkgs, ... }:

let
  cfg = config.boot.plymouth;
in
{
  options = {
    boot.plymouth = {
      enable = lib.mkEnableOption "Plymouth graphical boot splash";

      theme = lib.mkOption {
        type = lib.types.str;
        default = "matrix";
        description = "Plymouth theme name (see `plymouth-set-default-theme --list`).";
      };

      extraThemes = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ 
        plymouth-matrix-theme
          ];
        description = "Additional Plymouth theme packages.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # --------------------------------------------------------------------- #
    # 1. Enable Plymouth itself
    # --------------------------------------------------------------------- #
    boot.plymouth = {
      enable = true;
      theme = cfg.theme;
      # If you bring your own theme packages, they will be installed
      themePackages = cfg.extraThemes;
    };

    # --------------------------------------------------------------------- #
    # 2. Quiet boot – hide kernel messages (the splash will cover them)
    # --------------------------------------------------------------------- #
    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # --------------------------------------------------------------------- #
    # 3. Make sure the initrd can start Plymouth early
    # --------------------------------------------------------------------- #
    boot.initrd.systemd.enable = true;

    # --------------------------------------------------------------------- #
    # 4. (Optional) Install plymouth tools for debugging / theme switching
    # --------------------------------------------------------------------- #
    environment.systemPackages = with pkgs; [
      plymouth
    ];
  };
}
