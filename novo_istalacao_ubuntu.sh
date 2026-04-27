#!/bin/bash
## v1 - 26/04/2026



# begin - Configuracao inicial - escolha do terminal utilizado

# Pergunta ao usuário qual terminal utiliza
echo "Qual terminal você utiliza?"
echo "1 - bash"
echo "2 - zsh"
read -p "Digite o número da opção: " escolha

# Define a variável TERMINAL com base na escolha
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
# end - Configuracao inicial - escolha do terminal utilizado



echo "Atualizando repositórios..."
sleep 1
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Atualiza e instala pacotes básicos
sudo apt update -y && sudo apt upgrade -y
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install ubuntu-restricted-extras -y

## instala Nala (usar ao invés do APT)
# sudo apt install nala -y

# instala preload
sudo nala install preload -y


### begin -- Script de instalação do Homebrew e pacotes de desenvolvimento

# Instala dependências necessárias para o Homebrew
echo "Instalando dependências..."
sleep 1
sudo apt install build-essential curl file git -y

# Instala o Homebrew
echo "Instalando Homebrew..."
sleep 1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configura o PATH para o Homebrew
echo "Configurando PATH..."
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/."$TERMINAL"rc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Verifica instalação
brew --version
sleep 1

# Instala pacotes de desenvolvimento via Homebrew
echo "Instalando pacotes de desenvolvimento..."
sleep 1
brew install \
    git \        # Git para controle de versão
    node \       # Node.js para desenvolvimento JavaScript
    python \     # Python para scripts e automação
    docker \     # Docker para containers
    neovim \     # Editor de texto avançado
    wget \       # Ferramenta de download
    htop \       # Monitor de processos
    nvm \        # Node Version Manager
    eza \        # Substituto moderno para ls
    bat \        # Substituto moderno para cat
    starship     # Prompt bonito e customizável

# Configura alias eza e bat
echo 'alias cat="bat"' >> ~/."$TERMINAL"rc
echo 'alias ls="eza -lha"' >> ~/."$TERMINAL"rc

# begin - Instala FiraCode Nerd Font
echo "Instalando FiraCode Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O /tmp/FiraCode.zip
unzip -o /tmp/FiraCode.zip -d /tmp/FiraCodeNF
cp /tmp/FiraCodeNF/*.ttf ~/.local/share/fonts/
# Atualiza cache de fontes
fc-cache -fv
# Se GNOME Terminal estiver presente, aplica a fonte automaticamente
if command -v gsettings &> /dev/null; then
    PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ font 'FiraCode Nerd Font Mono 12'
    echo "Fonte FiraCode Nerd Font aplicada automaticamente no GNOME Terminal."
else
    echo "Fonte instalada. Configure manualmente nas preferências do seu terminal."
fi

echo "Instalação concluída! Abra um novo terminal para ver a FiraCode Nerd Font em ação."
sleep 2
# end - Instala FiraCode Nerd Font

# Configura starship inicializar no temrinal
echo 'eval "$(starship init '"$TERMINAL"')" ' >> ~/."$TERMINAL"rc
starship preset catppuccin-powerline -o ~/.config/starship.toml

# Configura NVM no bashrc
echo "Configurando NVM..."
mkdir -p ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/."$TERMINAL"rc
echo '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"' >> ~/."$TERMINAL"rc
echo '[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"' >> ~/."$TERMINAL"rc
source  ~/."$TERMINAL"rc

# Atualiza todos os pacotes do Homebrew
echo "Atualizando pacotes do Homebrew..."
sleep 2
brew update && brew upgrade

echo "Instalação e configuração Brew concluída com sucesso!"
sleep 2
### end -- Script de instalação do Homebrew e pacotes de desenvolvimento


## Instalando pacotes e programas do repositório deb do Ubuntu
sudo apt install wine build-essential libssl-dev flatpak libfuse2 gdebi gnome-tweaks -y

## Configura Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

## Apps Flatpak - Bazaar | Gnome Extension Manager
flatpak install flathub \
    io.github.kolunmi.Bazaar \              # Loja de aplicativos Flatpak (Bazaar)
    com.mattjakeman.ExtensionManager \      # Gerenciador de extensões do GNOME
    io.github.getnf.embellish \             # Ferramenta de customização visual (Embellish)
    -y                                      # Confirma a instalacao caso o flatpak solicite

## Melhora tempo de boot do Snap
sudo snap set system refresh.retain=2

# Cria arquivo de configuração de swappiness
echo "Configurando vm.swappiness..."
sleep 1
sudo sh -c 'echo "vm.swappiness=10" > /etc/sysctl.d/99-custom-swappiness.conf'

# Aplica as configurações imediatamente
sudo sysctl --system
