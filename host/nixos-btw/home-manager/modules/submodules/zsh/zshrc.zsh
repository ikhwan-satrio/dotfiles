
bindkey "^[[1;5C" forward-word      # Ctrl + Right Arrow
bindkey "^[[1;5D" backward-word     # Ctrl + Left Arrow
 
# Alt + Arrow (alternatif)
bindkey "^[[1;3C" forward-word      # Alt + Right Arrow
bindkey "^[[1;3D" backward-word     # Alt + Left Arrow

# Home & End keys
bindkey "^[[H" beginning-of-line    # Home
bindkey "^[[F" end-of-line          # End

# Delete key
bindkey "^[[3~" delete-char         # Delete

# Ctrl + Backspace & Delete
bindkey "^H" backward-kill-word     # Ctrl + Backspace
bindkey "^[[3;5~" kill-word         # Ctrl + Delete


# Navigation
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT

# History
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY SHARE_HISTORY

# Completion
setopt COMPLETE_IN_WORD ALWAYS_TO_END AUTO_MENU AUTO_LIST

# Misc
setopt INTERACTIVE_COMMENTS EXTENDED_GLOB

export PATH=$HOME/.local/bin:$PATH

# Lazy load completions (speed optimization)
autoload -Uz compinit
if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $ZDOTDIR/.zcompdump
else
  compinit -C -d $ZDOTDIR/.zcompdump
fi

# Starship, direnv, zoxide, fzf
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

if command -v fzf-share >/dev/null 2>&1; then
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"
fi

# --- ASDF ---
if command -v asdf >/dev/null 2>&1; then
    if [[ -z "$ASDF_DATA_DIR" ]]; then
              _asdf_shims="$HOME/.asdf/shims"
    else
        _asdf_shims="$ASDF_DATA_DIR/shims"
    fi
    if [[ ! "$PATH" == *"$_asdf_shims"* ]]; then
        export PATH="$_asdf_shims:$PATH"
    fi
    unset _asdf_shims
fi

# --- Bun ---
if [[ -d "$HOME/.cache/.bun" ]]; then
    export BUN_INSTALL="$HOME/.cache/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    eval "$(bun completions)"  # Uncomment jika perlu
fi

# --- Composer ---
if command -v composer >/dev/null 2>&1; then
    export PATH="$(asdf where php)/.composer/vendor/bin:$PATH"
fi

# --- Java ---
if command -v java >/dev/null 2>&1; then
    export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 | grep "java.home" | awk '{print $3}')
fi

# --- Golang ---
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# --- Rust/Cargo ---
if command -v cargo >/dev/null 2>&1; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# --- Functions ---
function nsp() {
    nix-shell --run zsh
}

function toggle_screen_timeout() {
    if systemctl --user is-active --quiet swayidle-niri.service; then
        systemctl --user stop swayidle-niri.service
        echo "Screen timeout disabled"
    else
        systemctl --user start swayidle-niri.service
        echo "Screen timeout enabled"
    fi
}

function toggle_conservation_mode() {
    local path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
    if [[ -f "$path" ]]; then
        local current_status=$(cat "$path")
        if [[ "$current_status" -eq 1 ]]; then
            echo "Conservation Mode: OFF"
            echo 0 | sudo tee "$path"
        else
            echo "Conservation Mode: ON"
            echo 1 | sudo tee "$path"
        fi
    else
        echo "File $path tidak ditemukan. Apakah Conservation Mode didukung?"
    fi
}

# Spicetify PATH
export PATH="$HOME/.spicetify:$PATH"
