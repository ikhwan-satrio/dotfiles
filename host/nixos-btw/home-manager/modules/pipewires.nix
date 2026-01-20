{ pkgs, ... }:

let
  rnnoise-plugin-path = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
in
{
  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoiser.conf".text = ''
    context.modules = [
      { name = libpipewire-module-filter-chain
        args = {
          node.description = "Microphone Jernih (RNNoise)"
          media.name       = "Microphone Jernih (RNNoise)"
          filter.graph = {
            nodes = [
              {
                type   = ladspa
                name   = rnnoise
                plugin = "${rnnoise-plugin-path}"
                label  = noise_suppressor_mono
                control = {
                  "VAD Threshold (%)" = 50.0
                  "VAD Grace Period (ms)" = 200
                }
              }
            ]
          }
          capture.props = {
            node.name = "capture.rnnoise_source"
            node.passive = true
            audio.rate = 48000
          }
          playback.props = {
            node.name = "rnnoise_source"
            media.class = Audio/Source
            audio.rate = 48000
          }
        }
      }
    ]
  '';
}
