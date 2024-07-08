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


## Instala gnome tweak
sudo apt install gnome-software-plugin-flatpak -y &&

## Instalando pacotes Snap ##
sudo snap install code --classic &&  
##sudo snap install --edge node --classic && 
sudo snap install postman &&  
sudo snap install spotify &&
sudo snap install notion-snap-reborn &&
sudo snap install isoimagewriter


## Adicionando repositório Flathub ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && 

## Instalando Apps do Flathub ##
sudo flatpak install flathub com.obsproject.Studio -y &&


##minimize dash to dock
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' &&


sudo apt install chrome-gnome-shell -y&& 


##install java 17
sudo apt install openjdk-17-jdk -y&&


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

#Fim do Script # 
echo "Finalizado" &&

##Torna ZSH padrao
chsh -s $(which zsh)


