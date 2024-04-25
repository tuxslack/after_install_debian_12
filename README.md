Post installation script developed for Debian 12 live Gnome base, based on my use of programs, configurations and customizations.
Link to download the ISO:
https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.4.0-amd64-gnome.iso

Make all improvements (recommended):
```
curl -o pos_install_complete.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/pos_install_complete.sh && chmod +x pos_install_complete.sh && ./pos_install_complete.sh && rm pos_install_complete.sh
```
Improvements separated by categories:


Activating the contrib and non-free repository and install flatpak support and flathub repository:
```
curl -o activating_repo_apps.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/activating_repo_apps.sh && chmod +x activating_repo_apps.sh && ./activating_repo_apps.sh && rm activating_repo_apps.sh
```
Change firefox ESR to Current:

```
curl -o change_firefox_esr_to_firefox.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/change_firefox_esr_to_firefox.sh && chmod +x change_firefox_esr_to_firefox.sh && ./change_firefox_esr_to_firefox.sh && rm change_firefox_esr_to_firefox.sh
```
Codecs and tweaks installer:
`
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
`
```
curl -o codecs_and_tweaks_installer.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/codecs_and_tweaks_installer.sh && chmod +x codecs_and_tweaks_installer.sh && ./codecs_and_tweaks_installer.sh && rm codecs_and_tweaks_installer.sh
```
Font corrections:
```
curl -o font_corrections.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/font_corrections.sh && chmod +x font_corrections.sh && ./font_corrections.sh && rm font_corrections.sh
```
Unnecessary Apps Remover:
`
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
    gnome-music`
```
curl -o unnecessary_apps_remover.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/unnecessary_apps_remover.sh && chmod +x unnecessary_apps_remover.sh && ./unnecessary_apps_remover.sh && rm unnecessary_apps_remover.sh
```
Switch Radeon to Amdgpu on Debian-based distros:

Enable amdgpu drive and disable Radeon drive on Linux, tested on Debian 12, but should work on any Debian based distro. Below is a list of all GPU models from the ‘Sea Islands’ and ‘Southern Islands’ families. If your GPU is on this list, then the procedure will probably be necessary.

Tahiti, Bonaire, Hawaii, Pitcairn, Cape Verde, Oland.
```
curl -o radeon_to_amdgpu.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/radeon_to_amdgpu.sh && chmod +x radeon_to_amdgpu.sh && ./radeon_to_amdgpu.sh && rm radeon_to_amdgpu.sh
```
install and set fira fonts:
```
curl -o fira_fonts.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/fira_fonts.sh && chmod +x fira_fonts.sh && ./fira_fonts.sh && rm fira_fonts.sh
```
Change Bash to Zsh:
```
curl -o change_bash_to_zsh.sh https://raw.githubusercontent.com/phaleixo/after_install_debian_12/main/change_bash_to_zsh.sh && chmod +x change_bash_to_zsh.sh && ./change_bash_to_zsh.sh && rm change_bash_to_zsh.sh
```

