# Add somewhere
# (waybar.overrideAttrs (oldAttrs: {
#   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
# }))
{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (config.modules.colorScheme) colors;
  desktopCfg = config.modules.desktop;
  osDesktopEnabled = osConfig.modules.system.desktop.enable;
  hyprland = config.wayland.windowManager.hyprland.package;
  startupScripts = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
  '';
  # ${pkgs.swww}/bin/swww init &
  # sleep 1
  # ${pkgs.swww}/bin/swww img ${./wallpaper.png} &

in
lib.mkIf (osDesktopEnabled && desktopCfg.windowManager == "Hyprland") {
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ hyprland ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        border_size = 2;
        "col.active_border" = "rgb(${colors.fg1})";
        "col.inactive_border" = "rgb(${colors.bg2})";
        gaps_in = 4;
        gaps_out = 8;
        layout = "master";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 2;
      };

      input = {
        kb_layout = "us";
      };

      monitor = [ "eDP-1, highres, 0x0, 1" ];

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "border, 1, 5, default"
          "fade, 1, 5, smoothIn"
          "fadeDim, 1, 5, smoothIn"
          "windows, 1, 5, overshot, slide"
          "windowsMove, 1, 4, smoothIn, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "workspaces, 1, 6, default"
        ];
      };

      decoration = {
        drop_shadow = true;
        shadow_offset = "0 2";
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000055)";

        rounding = 8;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
        mfact = 0.5;
        new_on_top = true;
      };

      gestures = {
        workspace_swipe = false;
      };
    };
  };
}
