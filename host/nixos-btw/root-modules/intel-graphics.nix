{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ============================================================================
  # INTEL GRAPHICS SPECIALIZATION
  # Intel Alder Lake-P GT1 [UHD Graphics] - Device ID: 46a3
  # ============================================================================

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "i915.enable_guc=3" # Enable GuC/HuC firmware
      "i915.force_probe=46a3" # Force probe Alder Lake GPU
    ];
  };

  hardware = {
    # Enable firmware updates
    enableRedistributableFirmware = true;

    # Intel Graphics Hardware Acceleration
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        # Modern Intel GPUs (Gen 12+, Alder Lake)
        intel-media-driver # VAAPI (iHD) - hardware video decode/encode
        vpl-gpu-rt # oneVPL - Quick Sync Video runtime
        intel-compute-runtime # OpenCL & Level Zero compute
      ];
    };
  };

  services.xserver = {
    # Intel modesetting driver
    videoDrivers = [ "modesetting" ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Force modern iHD backend
  };
}
