#!/usr/bin/env bash

### Initial message
echo -e "\n       ############################################################"
echo -e "       #                      Change_bash_to_zsh                  #"
echo -e "       ############################################################ \n"
echo "For more information, visit the project link:"
echo "https://github.com/phaleixo/after_install_debian_12"

### Confirm script execution
read -p "Do you want to proceed? (y/n): " response
[[ "$response" != "y" ]] && inform "Operation canceled by the user." && exit 0

### check if the distribution is compatible
if [[ $(lsb_release -cs) = "bookworm" ]]
then
	echo ""
	echo ""
	echo -e "\e[32;1mDebian 12 Distribution.\e[m"
	echo "Continuing with the script..."
	echo ""
else
	echo -e "\e[31;1mDistribution not approved for use with this script.\e[m"
	exit 1
fi

### check if there is an internet connection.
if ping -q -c 3 -W 1 1.1.1.1 >/dev/null;
then
  	echo ""
	echo ""
	echo -e "\e[32;1mInternet connection OK.\e[m"
	echo "Continuing with the script..."
	echo ""
else
  	echo -e "\e[31;1mYou are not connected to the internet. Check your network or Wi-Fi connection before proceeding.\e[m"
	exit 1
fi

### Check for sudo privileges
sudo -v || (inform "sudo may not be installed or the user may not have sudo permissions." && exit 1)

### Install zsh and  fontconfig.
apps=(  
        zsh
        git
        fontconfig
	
)

for app_name in "${apps[@]}"; do
  if ! dpkg -l | grep -q "$app_name"; then
    sudo apt install "$app_name" -y
  else
    echo "[installed] - $app_name"
  fi
done
### Remove old folder zsh-autosuggestions and powerlevel10k:
rm -rf ~/.zsh/zsh-autosuggestions
rm -rf ~/.zsh/powerlevel10k

### install Zsh theme:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
echo 'source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

### Install Meslo fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip \
&& cd ~/.local/share/fonts && unzip Meslo.zip && rm Meslo.zip && fc-cache -fv
gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS Nerd Font Mono Regular 11'

###Install plugin zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc

## To make zsh the default shell:
echo "Change_bash_to_zsh:"
chsh -s $(which zsh)
echo "Start a new terminal session."

