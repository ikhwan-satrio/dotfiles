{
  config,
  pkgs,
  ...
}:
let
  catppuccin-zsh-syntax = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zsh-syntax-highlighting";
    rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
    sha256 = "Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
  };
in
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
      # Tambahkan Catppuccin theme
      {
        name = "catppuccin-zsh-syntax-highlighting";
        src = catppuccin-zsh-syntax;
        file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
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
      diary = "cd ~/Documents/'wanto fault' && nvim .";
      steam = "steam -system-composer";
    };

    initContent = builtins.readFile ./submodules/zsh/zshrc.zsh;
  };
}
