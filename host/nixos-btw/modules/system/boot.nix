{ ... }: {

  flake.nixosModules.boot =
    {
      inputs,
      pkgs,
      lib,
      self,
      system,
      ...
    }:
    {
      boot = {
        # Plymouth splash screen

        plymouth = {
          enable = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
        # kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
        consoleLogLevel = 3;
        initrd.kernelModules = [
          "ideapad_laptop"
          "i915"
        ];
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
          "video=eDP-1:1920x1080@60"
          "loglevel=3"
          "rd.udev.log_level=3"

          "i915.enable_guc=3" # Enable GuC/HuC firmware
          "i915.force_probe=46a3" # Force probe Alder Lake GPU
          "i915.enable_psr=0"
          "i915.enable_fbc=0"
        ];

        # GRUB bootloader
        loader = {
          grub = rec {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = false;
            configurationLimit = 3;
            extraEntriesBeforeNixOS = true;
            theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
            splashImage = "${theme}/splash_image.jpg";
          };
          efi.canTouchEfiVariables = true;
        };

        tmp = {
          useTmpfs = true;
          tmpfsSize = "4G";
          cleanOnBoot = true;
        };
      };

    };
}
