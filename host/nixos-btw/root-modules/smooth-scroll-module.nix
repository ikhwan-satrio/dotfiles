{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.smooth-scroll;
  pkg = pkgs.smooth-scroll-linux;

  defaultConfig = pkgs.writeText "smooth-scroll.toml" ''
    [scroll]
    damping = 0.85
    min_deceleration = 50.0
    max_deceleration = 200.0
    initial_speed = 600.0
    speed_factor = 1.0
    max_speed_increase_per_wheel_event = 400.0

    [stop]
    use_braking = true
    braking_dejitter_microseconds = 200000
    max_braking_times = 3
    use_mouse_movement_braking = true
  '';

  configFile = if cfg.configFile != null then cfg.configFile else defaultConfig;
in
{
  options.services.smooth-scroll = {
    enable = lib.mkEnableOption "smooth-scroll-linux mouse wheel smoothing daemon";

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to custom smooth-scroll.toml. Null = pakai default.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      defaultText = lib.literalExpression "pkgs.smooth-scroll-linux";
      description = "Package smooth-scroll-linux yang dipakai.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."smooth-scroll/smooth-scroll.toml".source = configFile;

    systemd.services.smooth-scroll = {
      description = "Smooth Scroll for Linux";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/smooth-scroll -c /etc/smooth-scroll/smooth-scroll.toml";
        Restart = "on-failure";
        RestartSec = 2;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        SupplementaryGroups = [ "input" ];
      };
    };

    users.groups.input = { };
  };
}
