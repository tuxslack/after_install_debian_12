#!/usr/bin/env bash


# Initial message
echo -e "\n       ############################################################"
echo -e "       #                  Tweaks pos install Debian 12            #"
echo -e "       ############################################################ \n"
echo "For more information, visit the project link:"
echo "https://github.com/phaleixo/after_install_debian_12"

# Confirm script execution
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

# Check for sudo privileges
sudo -v || (inform "sudo may not be installed or the user may not have sudo permissions." && exit 1)

#Activating the contrib and non-free repository
sudo apt-add-repository contrib -y
sudo apt-add-repository non-free -y
sudo apt update && sudo apt full-upgrade -y

#Install flatpak support and flathub repository
sudo apt install gnome-software-plugin-flatpak -y 
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

### Install codecs, fonts and tweaks.
apps=(  
        amd64-microcode 
	exfat-fuse 
	ffmpeg 
	ffmpegthumbnailer 
	firmware-amd-graphics 
	firmware-linux-nonfree 
	font-manager 
	fonts-croscore 
	fonts-noto 
	fonts-noto-extra 
	fonts-ubuntu 
	gamemode 
	gir1.2-gtop-2.0 
	gnome-browser-connector 
	gnome-firmware 
	gnome-tweaks 
	gstreamer1.0-plugins-ugly 
	gstreamer1.0-vaapi 
	gufw 
	hugo 
	libavcodec-extra 
	ldap-utils 
	libasound2-plugins 
	lolcat
	micro 
	vdpauinfo
	python3-pip
	python3
	gnome-boxes
	p7zip-rar
	ntp
	network-manager-config-connectivity-debian
	ttf-mscorefonts-installer
)

for app_name in "${apps[@]}"; do
  if ! dpkg -l | grep -q "$app_name"; then
    sudo apt install "$app_name" -y
  else
    echo "[installed] - $app_name"
  fi
done
### Adding/Confirming 32-bit architecture
sudo dpkg --add-architecture i386

### Remove Firefox ESR

sudo apt remove --purge firefox-esr -y

### Create a directory to store APT repository keys if it doesn't exist
sudo install -d -m 0755 /etc/apt/keyrings

### Import the Mozilla APT repository signing key
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

### The fingerprint should be 35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}'

### Add the Mozilla APT repository to your sources list
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

### Configure APT to prioritize packages from the Mozilla repository
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla 

### Update your package list and install the Firefox .deb package
sudo apt-get update && sudo apt-get install firefox -y && sudo apt-get install firefox-l10n-pt-br -y

### Remove unnecessary apps
apps_remove=(
    fcitx*
    mozc*
    xiterm+thai*
    mlterm*
    xterm*
    hdate*
    kasumi*
    gnome-games*
    im*
    goldendict*
    hdate*
    uim*
    thunderbird*
    gnome-music
    
)

### uninstall and clean
for app_name_remove in "${apps_remove[@]}"; do
    sudo apt remove --purge "$app_name_remove" -y
done

sudo apt autoremove && sudo apt autoclean

### Fira fonts

mkdir -p ~/.fonts

wget --version > /dev/null

if [[ $? -ne 0 ]]; then
        echo "wget not available , installing"
        sudo apt update && sudo apt install wget -y
fi

unzip >> /dev/null

if [[ $? -ne 0 ]]; then
        echo "unzip not available , installing"
        sudo apt update && sudo apt install unzip -y
fi


wget -O fonts.zip "https://github.com/mozilla/Fira/archive/refs/tags/4.202.zip"

wget -O firacode.zip "https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip"

if [[ $? -ne 0 ]]; then
        echo "Downloading failed , exiting"
        exit 1
fi

unzip fonts.zip -d ~/.fonts
unzip firacode.zip -d ~/.fonts

clear
echo "purging fonts cache "
fc-cache -v -f
clear
echo "Done"
sleep 2
clear
echo "Setting default fonts "

gsettings set org.gnome.desktop.interface document-font-name 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.interface font-name 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Regular 11'
gsettings set org.gnome.nautilus.desktop font 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Fira Sans SemiBold 12"
clear

rm -rf fonts.zip
rm -rf firacode.zip

###Radeon to Amdgpu

# Check video driver
video_driver_info=$(lspci -k | grep amdgpu)
video_card_info=$(lspci | grep VGA)

if [[ "$video_driver_info" == *"Kernel driver in use: amdgpu"* ]]; then
    # Amdgpu driver is already active
    inform "Video card: '$video_card_info'\n----------------------------------------------------------------" "success"
    inform "The amdgpu driver is already active. No action required." "success"
elif [[ "$video_driver_info" == *"Kernel driver in use: radeon"* ]]; then
    # Switch from radeon to amdgpu
    inform "Video card: '$video_card_info'\n----------------------------------------------------------------" "success"
    inform "Switching driver from radeon to amdgpu..."
    sed_command='s/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 radeon.cik_support=0 amdgpu.cik_support=1 radeon.si_support=0 amdgpu.si_support=1"/'

    if sudo sed -i "$sed_command" /etc/default/grub && sudo update-grub; then
        inform "Driver configuration updated successfully. Restart the system to apply the changes." "success"
    else
        inform "Error updating GRUB or changing the driver. Please restart the system manually after fixing the issue." "error"
    fi
else
    # No AMDGPU or Radeon driver detected
    inform "Video card: '$video_card_info'" "error"
    inform "Unable to detect the AMDGPU or Radeon video driver on the system." "error"
fi


echo "Configuration completed. Press any key and close the terminal."
read -n 1 -s any_key
exit 0


