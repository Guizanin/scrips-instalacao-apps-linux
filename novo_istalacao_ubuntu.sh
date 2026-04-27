#!/bin/bash
## v3 - 26/04/2026
set -e  # Faz o script parar em caso de erro

# -------------------------------
# Configuração inicial - escolha do terminal
# -------------------------------
echo "Qual terminal você utiliza?"
echo "1 - bash"
echo "2 - zsh"
read -p "Digite o número da opção: " escolha

if [ "$escolha" == "1" ]; then
    TERMINAL="bash"
elif [ "$escolha" == "2" ]; then
    TERMINAL="zsh"
else
    echo "Opção inválida. Usando bash como padrão."
    TERMINAL="bash"
fi

echo "Você escolheu: $TERMINAL"
sleep 2

# -------------------------------
# Atualização de pacotes
# -------------------------------
echo "Atualizando repositórios..."
sleep 1
sudo apt update -y && sudo apt upgrade -y
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install -y ubuntu-restricted-extras unzip

# Instala Nala (se não estiver presente)
if ! command -v nala &> /dev/null; then
    sudo apt install -y nala
fi

# Instala preload
sudo nala install -y preload

# -------------------------------
# Instalação do Homebrew
# -------------------------------
echo "Instalando dependências..."
sudo apt install -y build-essential curl file git

echo "Instalando Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Configurando PATH..."
# Adiciona apenas uma linha correta ao rc do terminal
grep -qxF 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.${TERMINAL}rc || echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.${TERMINAL}rc

# Carrega o ambiente imediatamente
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Verifica instalação
if command -v brew &> /dev/null; then
    brew --version
else
    echo "Homebrew não encontrado no PATH. Abra um novo terminal ou rode:"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
fi

# -------------------------------
# Instalação de pacotes via Homebrew
# -------------------------------
echo "Instalando pacotes de desenvolvimento..."
brew install git node python docker neovim wget htop nvm eza bat starship

# Configura alias
grep -qxF 'alias cat="bat"' ~/.${TERMINAL}rc || echo 'alias cat="bat"' >> ~/.${TERMINAL}rc
grep -qxF 'alias ls="eza -lha"' ~/.${TERMINAL}rc || echo 'alias ls="eza -lha"' >> ~/.${TERMINAL}rc

# -------------------------------
# Instalação da FiraCode Nerd Font
# -------------------------------
echo "Instalando FiraCode Nerd Font..."
rm -f /tmp/FiraCode.zip
rm -rf /tmp/FiraCodeNF
mkdir -p ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O /tmp/FiraCode.zip
unzip -o /tmp/FiraCode.zip -d /tmp/FiraCodeNF
cp /tmp/FiraCodeNF/*.ttf ~/.local/share/fonts/
fc-cache -fv

# -------------------------------
# Configuração do Starship
# -------------------------------
echo "Configurando Starship..."
grep -qxF "eval \"\$(starship init $TERMINAL)\"" ~/.${TERMINAL}rc || echo "eval \"\$(starship init $TERMINAL)\"" >> ~/.${TERMINAL}rc
starship preset catppuccin-powerline -o ~/.config/starship.toml

# -------------------------------
# Configuração do NVM
# -------------------------------
echo "Configurando NVM..."
mkdir -p ~/.nvm
grep -qxF 'export NVM_DIR="$HOME/.nvm"' ~/.${TERMINAL}rc || echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.${TERMINAL}rc
grep -qxF '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"' ~/.${TERMINAL}rc || echo '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"' >> ~/.${TERMINAL}rc
grep -qxF '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"' ~/.${TERMINAL}rc || echo '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"' >> ~/.${TERMINAL}rc

source ~/.${TERMINAL}rc

# -------------------------------
# Atualização do Homebrew
# -------------------------------
echo "Atualizando pacotes do Homebrew..."
brew update && brew upgrade

# -------------------------------
# Instalação de pacotes adicionais
# -------------------------------
sudo apt install -y wine build-essential libssl-dev flatpak libfuse2 gdebi gnome-tweaks

# Configura Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Instala apps Flatpak
flatpak install -y flathub io.github.kolunmi.Bazaar com.mattjakeman.ExtensionManager io.github.getnf.embellish

# -------------------------------
# Configurações adicionais
# -------------------------------
sudo snap set system refresh.retain=2

echo "Configurando vm.swappiness..."
sudo sh -c 'echo "vm.swappiness
