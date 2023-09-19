#!/bin/bash

#------------------------------------------------------------
# URLs
#------------------------------------------------------------

URL_GHCUP="https://get-ghcup.haskell.org"
URL_RUSTUP="https://sh.rustup.rs"
URL_SDKMAN="https://get.sdkman.io"
URL_NVM="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh"
URL_OMF="https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install"
URL_YAY="https://aur.archlinux.org/yay.git"

#------------------------------------------------------------
# TEMP DIR
#------------------------------------------------------------

YAY=$(mktemp -d)

#------------------------------------------------------------
# GRAPHICS
#------------------------------------------------------------

sudo pacman -S --needed --noconfirm \
        nvidia \
        nvidia-utils \
                && sudo mkinitcpio -p linux

#------------------------------------------------------------
# BLUETOOTH
#------------------------------------------------------------

sudo pacman -S --needed --noconfirm \
        bluez \
        bluez-utils \
                && sudo systemctl enable bluetooth.service \
                && sudo systemctl start bluetooth.service

#------------------------------------------------------------
# UTILS
#------------------------------------------------------------

sudo pacman -S --needed --noconfirm \
        helix \
        fd \
        kitty \
        xclip \
        bat \
        fish \
        ripgrep \
        exa \
        base-devel \
        zip \
        less \
        git \
        gnome-browser-connector \
        gnome-sound-recorder \
        cuda-tools \
        clang \
        cmake \
        llvm \
        vivaldi

#------------------------------------------------------------
# PROGRAMMING LANGUAGES
#------------------------------------------------------------

curl -Lfs $URL_GHCUP  | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
                        BOOTSTRAP_HASKELL_ADJUST_BASHRC=1 \
                        BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
                        bash
curl -Lfs $URL_RUSTUP | bash -s -- -y
curl -Lfs $URL_SDKMAN | bash
curl -Lfs $URL_NVM    | bash

#------------------------------------------------------------
# FONTS
#------------------------------------------------------------

sudo pacman -S --needed --noconfirm \
        ttf-jetbrains-mono-nerd \
        ttf-firacode-nerd \
        ttf-cascadia-code-nerd	\
        ttf-fira-sans

#------------------------------------------------------------
# YAY BINs
#------------------------------------------------------------

cd $YAY \
        && git clone $URL_YAY \
        && cd yay \
        && makepkg -si \
        && cd $HOME \
                && yay -S --needed --noconfirm --answerdiff=None \
                        papirus-icon-theme-git \
                        papirus-folders-git \
                        adw-gtk3-git \
                        nordvpn-bin \
                                && sudo systemctl enable nordvpnd \
                                        && sudo groupadd -r nordvpn \
                                        && sudo gpasswd  -a (whoami) nordvpn

#------------------------------------------------------------
# REMOVING BINs
#------------------------------------------------------------

sudo pacman -R --noconfirm \
        htop \
        vim \
        epiphany \
        gnome-console \
        gnome-text-editor \
        gnome-tour

#------------------------------------------------------------
# REMOVING LINKS
#------------------------------------------------------------

sudo rm -f /usr/share/applications/avahi-discover.desktop
sudo rm -f /usr/share/applications/bssh.desktop
sudo rm -f /usr/share/applications/bvnc.desktop
sudo rm -f /usr/share/applications/lstopo.desktop
sudo rm -f /usr/share/applications/qv4l2.desktop
sudo rm -f /usr/share/applications/qvidcap.desktop
sudo rm -f /usr/share/applications/fish.desktop
sudo rm -f /usr/share/applications/cmake-gui.desktop

#------------------------------------------------------------
# OH MY FISH
#------------------------------------------------------------

curl -Lfs $URL_OMF | fish -c "source - --noninteractive --yes" \
                  && fish -c "omf install sdk nvm pure ghcup rustup"

#------------------------------------------------------------
# FISH CONFIG
#------------------------------------------------------------

# SHELL VARs

echo "$(cat <<-EOF
set -Ux BAT_THEME base16
set -Ux LD_LIBRARY_PATH /opt/cuda/lib64
EOF
)" | fish -c "source -"

# PATH

echo "$(cat <<-EOF
fish_add_path /opt/cuda/bin
EOF
)" | fish -c "source -"

# FISH COLORS

echo "$(cat <<-EOF
set -U fish_color_autosuggestion brblack
set -U fish_color_cancel -r
set -U fish_color_command brgreen
set -U fish_color_comment brmagenta
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_end brmagenta
set -U fish_color_error brred
set -U fish_color_escape brcyan
set -U fish_color_history_current --bold
set -U fish_color_host normal
set -U fish_color_match --background=brblue
set -U fish_color_normal normal
set -U fish_color_operator cyan
set -U fish_color_param brblue
set -U fish_color_quote yellow
set -U fish_color_redirection bryellow
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path --underline
set -U fish_pager_color_completion normal
set -U fish_pager_color_description yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan
EOF
)" | fish -c "source -"

# KORA

echo "$(cat <<-EOF
#!/bin/sh

rm -rf ~/.config/nemo/
rm -rf ~/.config/cef_user_data/
rm -rf ~/.config/goa-1.0/
rm -rf ~/.config/pulse/
rm -rf ~/.config/neofetch/
rm -rf ~/.config/Code/
rm -rf ~/.config/darktable/
rm -rf ~/.config/GIMP/
rm -rf ~/.config/handlr/
rm -rf ~/.config/ibus/
rm -rf ~/.config/Insomnia/
rm -rf ~/.config/jgit/
rm -rf ~/.config/zoom.conf
rm -rf ~/.config/zoomus.conf

rm -rf ~/.cache/mesa_shader_cache
rm -rf ~/.cache/thumbnails
rm -rf ~/.cache/event-sound-cache*
rm -rf ~/.cache/flatpak/
rm -rf ~/.cache/libvirt/
rm -rf ~/.cache/nvim/
rm -rf ~/.cache/fontconfig/
rm -rf ~/.cache/gstreamer-1.0/
rm -rf ~/.cache/JNA/
rm -rf ~/.cache/kitty/
rm -rf ~/.cache/mesa_shader_cache/
rm -rf ~/.cache/main.kts.compiled.cache/
rm -rf ~/.cache/virt-manager/
rm -rf ~/.cache/qtile/
rm -rf ~/.cache/pip/
rm -rf ~/.cache/yarn/
rm -rf ~/.cache/ghcide
rm -rf ~/.cache/zoom
rm -rf ~/.cache/babl
rm -rf ~/.cache/coursier
rm -rf ~/.cache/darktable
rm -rf ~/.cache/gegl-0.4
rm -rf ~/.cache/gimp
rm -rf ~/.cache/gmic
rm -rf ~/.cache/gradle-completions
rm -rf ~/.cache/qt_compose_cache_little_endian_fedora
rm -rf ~/.cache/qtshadercache-x86_64-little_endian-lp64

rm -rf ~/.local/state/nvim
rm -rf ~/.local/state/wireplumber/

rm -rf ~/.local/share/gegl-0.4
rm -rf ~/.local/share/applications/
rm -rf ~/.local/share/fish/fish_history
rm -rf ~/.local/share/flatpak/
rm -rf ~/.local/share/xorg/
rm -rf ~/.local/share/qtile/
rm -rf ~/.local/share/gvfs-metadata/
rm -rf ~/.local/share/recently-used.xbel
rm -rf ~/.local/share/.vivaldi_reporting_data

rm -rf ~/.android/
rm -rf ~/.pki/
rm -rf ~/.npm/
rm -rf ~/.w3m/
rm -rf ~/.stack/

rm -rf ~/.cabal/
rm -rf ~/.zoom/
rm -rf ~/.m2/
rm -rf ~/.vscode/
rm -rf ~/.sbt/
rm -rf ~/.kube/
rm -rf ~/.gradle/
rm -rf ~/.ivy2/
rm -rf ~/.g8/
rm -rf ~/.docker/
rm -rf ~/.sonarlint/
rm -rf ~/.bash_history
rm -rf ~/.python_history
rm -rf ~/.serverauth.*
rm -rf ~/.angular-config.json
rm -rf ~/.node_repl_history
rm -rf ~/.Xauthority
rm -rf ~/.wget-hsts
rm -rf ~/.testcontainers.properties
rm -rf ~/.lesshst
rm -rf ~/.mupdf.history        
EOF
)" > $HOME/.local/bin/kora \

# ALIASES

echo "$(cat <<-EOF
alias -s b   "bat"
alias -s c   "builtin history clear && history -c && kora && printf '\033[2J\033[3J\033[1;1H'"
alias -s l   "exa"
alias -s la  "exa -a"
alias -s ll  "exa -l"
alias -s lla "exa -la"
alias -s r   "rm -r"
alias -s rf  "rm -rf"
alias -s hx  "helix"
EOF
)" | fish -c "source -"

