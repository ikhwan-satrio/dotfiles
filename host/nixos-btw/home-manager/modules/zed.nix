{ inputs,pkgs,lib,... }:{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "typescript" "javascript" "deno" ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      hour_format = "hour24";
      vim_mode = true;
    };
  };
}
