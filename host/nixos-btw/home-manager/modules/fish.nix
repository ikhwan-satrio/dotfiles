{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];

    shellAliases = {
      ns  = "sudo nixos-rebuild switch --flake .#nixos-btw --impure";
      vim = "nvim";
      v   = "nvim";
    };

    interactiveShellInit = ''
      if status is-interactive
          set -gx PATH $HOME/.cache/.bun/bin $PATH
          set -gx PATH $HOME/.config/composer/vendor/bin $PATH
          set -gx PATH $HOME/.flutter/bin $PATH
      end
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
