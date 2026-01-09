{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    # Pakai plugin manual (lebih cepat dari Oh My Zsh)
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first -1";
      ll = "eza --icons --group-directories-first -lah";
      la = "eza --icons --group-directories-first -A";
      l = "eza --icons --group-directories-first -lh";
      ns = "sudo nixos-rebuild switch --flake '.#nixos-btw' --impure";
    };

    initContent = builtins.readFile ./submodules/zsh/zshrc.zsh;
  };
}
