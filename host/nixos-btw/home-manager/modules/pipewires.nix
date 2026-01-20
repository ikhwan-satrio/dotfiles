{
  pkgs,
  ...
}:
{
  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoiser.conf".text = ''
    context.modules = [
      {
        name = libpipewire-module-filter-chain
        args = {
          node.description = "Noise Canceling Microphone"
          media.name = "Noise Canceling Microphone"
          filter.graph = {
            nodes = [
              {
                type = ladspa
                name = rnnoise
                plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so"
                label = noise_suppressor_mono
                control = {
                  "VAD Threshold (%)" = 50.0
                }
              }
            ]
          }
          audio.position = [ MONO ]
          capture.props = {
            node.name = "capture.rnnoise_source"
            node.passive = true
          }
          playback.props = {
            node.name = "rnnoise_source"
            media.class = Audio/Source
          }
        }
      }
    ]
  '';
}
