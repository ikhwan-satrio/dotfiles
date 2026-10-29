{ ... }: {

  flake.nixosModules.hardware =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      hardware = {
        bluetooth.enable = true;
        cpu.intel.updateMicrocode = true;

        # Enable firmware updates
        enableRedistributableFirmware = true;

        # Intel Graphics Hardware Acceleration
        graphics = {
          enable = true;
          enable32Bit = true;

          extraPackages = with pkgs; [
            vulkan-loader
            mesa

            # Modern Intel GPUs (Gen 12+, Alder Lake)
            libvdpau-va-gl # VDPAU via VA-API
            intel-vaapi-driver # fallback driver i965
            intel-media-driver # VAAPI (iHD) - hardware video decode/encode
            intel-compute-runtime # OpenCL & Level Zero compute
            vpl-gpu-rt # oneVPL - Quick Sync Video runtime
          ];
        };
      };

    };
}
