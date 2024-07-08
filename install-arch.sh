#!/bin/bash
##v1 - 20244/07/08

echo instalando...

yay -S spotify --noconfirm &&
##sudo pacman -S --needed base-devel git
yay -S google-chrome --noconfirm &&
yay java 17 &&
yay jetbrains toolbox &&
yay -S extra/plasma-meta --noconfirm &&
##yay -S latte-dock --noconfirm

sudo pacman -S zsh &&
##inicia configuracao zsh
zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f && 0 &&
##plugin zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z &&
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install &&
sudo dnf install fd-find && export FZF_DEFAULT_COMMAND='fdfind --type f' && export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --height=80%"

# plugins=(
#     fzf
#     git
#     history-substring-search
#     colored-man-pages
#     zsh-autosuggestions
#     zsh-syntax-highlighting
#     zsh-z
# )

##install OhMyPosh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo ...FINALIZADO SCRIPT
