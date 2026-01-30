let
  noctalia-lock = "noctalia-shell ipc call lockScreen lock";
in
{
  xdg.configFile."hypr/hypridle.conf".text = ''
    listener {
      timeout = 300                                    # 10 menit
        on-timeout = ${noctalia-lock}
    }

    listener {
        timeout = 600                                    # 7.5 menit
        on-timeout = niri msg action power-off-monitors
        on-resume = niri msg action power-on-monitors
    }

    listener {
        timeout = 1800                                   # 30 menit
        on-timeout = systemctl suspend
    }
  '';
}
