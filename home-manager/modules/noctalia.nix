{
  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        fancy-audiovisualizer = {
          enabled = true;
          name = "fancy audiovisualizer";
        };
        translator = {
          enabled = true;
          name = "Translator";
        };
        update-count = {
          enabled = true;
          name = "Update Count";
        };
        world-clock = {
          enabled = true;
          name = "World Clock";
        };
      };
      version = 2;
    };
  };
}
