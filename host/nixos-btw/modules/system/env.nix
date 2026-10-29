{ ... }: {

  flake.nixosModules.env =
    {
      inputs,
      pkgs,
      lib,
      self,
      ...
    }:
    {
      environment.sessionVariables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";

        STEEL_HOME = "$HOME/.steel";
        DXVK_FRAME_RATE = "60";
        VDPAU_DRIVER = "va_gl";
        __GLX_VENDOR_LIBRARY_NAME = "mesa";
        WLR_NO_HARDWARE_CURSORS = "1";
        LIBVA_DRIVER_NAME = "iHD";
      };

      environment.variables = {
        TMPDIR = "/tmp";
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };

    };
}
