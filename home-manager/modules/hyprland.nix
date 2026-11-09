{ inputs,config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    plugins = [ inputs.gloview.packages.${pkgs.system}.gloview ];

    settings = {
      # Environment variables
      env = [
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_STYLE_OVERRIDE,kvantum"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "GDK_BACKEND,wayland,x11"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland,x11,windows"
        "CLUTTER_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "TERMINAL,kitty"
        "TERMINAL_COMMAND,kitty"
      ];

      # General settings
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(c7c8ffff)";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Input settings
      input = {
        natural_scroll = false;
        touchpad = {
          natural_scroll = true;
        };
      };

      # Decoration settings
      decoration = {
        rounding = 0;
        rounding_power = 5;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Gestures
      gestures = {
        workspace_swipe_distance = 700;
        workspace_swipe_cancel_ratio = 0.15;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      # Misc settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = "0x1e1e2e";
      };

      # Xwayland
      xwayland = {
        enabled = true;
      };

      # Monitor configuration
      monitor = [
        "eDP-1,1920x1080@144,0x0,1"
      ];

      # Keybindings
      bind = [
        "SUPER, TAB, gloview:toggle"

        # Application launchers
        "SUPER,Return,exec,kitty"
        "SUPER,B,exec,zen"
        "SUPER,E,exec,kitty --title yazi -e yazi"

        # Window management
        "SUPER,Q,closewindow"
        "SUPER,FULLSCREEN,fullscreen"
        "SUPER,SPACE,togglefloating"

        # Focus movement
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
        "SUPER,h,movefocus,l"
        "SUPER,l,movefocus,r"
        "SUPER,j,movefocus,d"
        "SUPER,k,movefocus,u"

        # Window movement
        "SUPER ALT,left,movewindow,l"
        "SUPER ALT,right,movewindow,r"
        "SUPER ALT,up,movewindow,u"
        "SUPER ALT,down,movewindow,d"
        "SUPER ALT,h,movewindow,l"
        "SUPER ALT,l,movewindow,r"
        "SUPER ALT,j,movewindow,d"
        "SUPER ALT,k,movewindow,u"

        # Workspace switching (1-5)
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"

        # Move window to workspace
        "SUPER SHIFT,1,movetoworkspace,1"
        "SUPER SHIFT,2,movetoworkspace,2"
        "SUPER SHIFT,3,movetoworkspace,3"
        "SUPER SHIFT,4,movetoworkspace,4"
        "SUPER SHIFT,5,movetoworkspace,5"

        # Noctalia panel toggles
        "SUPER,R,exec,noctalia msg panel-toggle launcher"
        "SUPER,V,exec,noctalia msg panel-toggle clipboard"
        "SUPER,W,exec,noctalia msg panel-toggle wallpaper"
        "SUPER SHIFT,Q,exec,noctalia msg panel-toggle session"
        "SUPER SHIFT,W,exec,noctalia msg wallpaper-random"
        "SUPER SHIFT,P,exec,noctalia msg media toggle"

        # Media keys
        "XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "XF86MonBrightnessUp,exec,brightnessctl set 2%+"
        "XF86MonBrightnessDown,exec,brightnessctl set 2%-"
        "XF86AudioPlay,exec,playerctl play-pause"
        "XF86AudioPrev,exec,playerctl previous"
        "XF86AudioNext,exec,playerctl next"

        # Screenshots
        "Print,exec,hyprshot -m output -o ~/Pictures/Screenshots -z"

        # Resize submap
        "ALT,R,submap,resize"
      ];

      # Mouse bindings
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];

      # Locked bindings
      bindel = [
        "XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "XF86MonBrightnessUp,exec,brightnessctl set 2%+"
        "XF86MonBrightnessDown,exec,brightnessctl set 2%-"
      ];

      bindl = [
        "XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "XF86AudioPlay,exec,playerctl play-pause"
        "XF86AudioPrev,exec,playerctl previous"
        "XF86AudioNext,exec,playerctl next"
      ];

      # Resize submap
      submap = [
        "resize,bind,right,resizewindow, 10 0"
        "resize,bind,left,resizewindow, -10 0"
        "resize,bind,up,resizewindow, 0 -10"
        "resize,bind,down,resizewindow, 0 10"
        "resize,bind,escape,submap,reset"
      ];

      # Gestures
      gesture = [
        "3, horizontal, workspace"
        "3, down, ALT, closewindow"
        "3, up, SUPER:1.5, fullscreen"
      ];

      # Window rules
      windowrulev2 = [
        "float,title:^(yazi)$"
        "size 900 600,title:^(yazi)$"
        "center,title:^(yazi)$"
        "float,title:^(termfilechooser)$"
        "size 900 600,title:^(termfilechooser)$"
        "center,title:^(termfilechooser)$"
        "rounding 10,title:^(yazi)$"
        "opacity 0.95 0.85,title:^(yazi)$"
      ];

      # Autostart
      exec-once = [
        "systemctl --user start hyprpolkitagent"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "noctalia -d"
        "gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'"
        "gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''"
        "kwriteconfig5 --file kdeglobals --group General --key TerminalApplication kitty"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
      ];
    };
  };
}
