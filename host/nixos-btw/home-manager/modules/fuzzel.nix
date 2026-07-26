{
  fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        width = 40;
        horizontal-pad = 24;
        vertical-pad = 12;
        inner-pad = 10;
        layer = "overlay";
        icon-theme = "Papirus-Dark";
        dpi-aware = "auto";
        lines = 8;
        prompt = "❯   ";
      };

      colors = {
        background   = "0f0f17f2";  # nyaris hitam, sedikit transparan
        text         = "c0caf5ff";  # foreground khas tokyonight
        match        = "7aa2f7ff";  # biru terang buat highlight match
        selection    = "1a1b26ff";  # background lebih gelap dari base
        selection-text  = "c0caf5ff";
        selection-match = "bb9af7ff"; # ungu buat match di item terpilih
        border       = "7aa2f7ff";  # biru sebagai aksen border
      };

      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
