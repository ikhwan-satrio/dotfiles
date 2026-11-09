{ ... }: {

  flake.nixosModules.gaming =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            inhibit_screensaver = 1;
          };
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 0;
          };
          cpu = {
            park_cores = "no";
            pin_cores = "yes";
          };
        };
      };

      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
        "vm.swappiness" = 10;
        "kernel.sched_autogroup_enabled" = 0;
        "net.core.rmem_max" = 2500000;
      };
    };
}
