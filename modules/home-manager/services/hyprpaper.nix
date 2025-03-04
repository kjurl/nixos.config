{ lib, config, ... }:
let
  inherit (config.modules.desktop) wallpaper;
  cfg = config.modules.services.hyprpaper;
in
lib.mkIf cfg.enable {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper.default ];
      wallpaper = [ ", ${wallpaper.default}" ];
    };
  };
}
