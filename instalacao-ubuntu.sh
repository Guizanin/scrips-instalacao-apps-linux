#!/bin/bash
##v2 - 02/07/2024

echo Atualizando repositórios...

## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock ;


## Atualizando o repositório ##
sudo apt update -y &&
sudo apt upgrade -y &&
sudo apt install ubuntu-restricted-extras -y &&


## Instalando pacotes e programas do repositório deb do Ubuntu ## libfuse -> jetbrainstoolbox, gdebi para pacotes .deb
sudo apt install python3 python3-pip wine git build-essential libssl-dev flatpak  git libfuse2 gdebi -y &&

##instala postgres
sudo apt install postgresql -y &&

## Instala gnome tweak
sudo apt install gnome-software-plugin-flatpak -y &&

## Instalando pacotes Snap ##
sudo snap install code --classic &&  
##sudo snap install --edge node --classic && 
sudo snap install postman &&  
sudo snap install spotify &&
sudo snap install notion-snap-reborn &&
sudo snap install isoimagewriter &&
sudo snap install dbeaver-ce &&


## Adicionando repositório Flathub ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && 


##minimize dash to dock
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' &&


sudo apt install chrome-gnome-shell -y && 

##install maven
sudo apt install maven -y &&
##install java 17
sudo apt install openjdk-17-jdk -y &&


##install nvm, 14, 18 and yarn
sudo apt install curl -y &&
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash  &&
source ~/.bashrc   &&
nvm install 12.7.0 &&
nvm install 18 &&
nvm install 14.17.0 &&
nvm use 14 &&
npm install -g yarn &&

##Instalado ZSH
sudo apt install zsh -y &&


## Atualização do sistema ##
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoclean -y && sudo apt autoremove -y &&

##Torna ZSH padrao
echo "export SHELL=/bin/zsh" >> .bash_profile &&
echo "exec /bin/zsh -l" >> .bash_profile &&
echo "eval "$(oh-my-posh init zsh --config ~/.poshthemes/catppuccin_frappe.omp.json)"" >> .zshrc &&
echo $SHELL

#Fim do Script # 
echo "Finalizado"
