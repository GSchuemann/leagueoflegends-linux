#!/bin/bash
echo "*************************************************"
echo "Creating wine prefix and performing winetricks."
echo "*************************************************"

WINEDEBUG=-all WINEARCH=win32 WINEPREFIX=/home/$USER/League\ of\ Legends winetricks -q directx9 d3dx9_43 winxp

echo "*************************************************"
echo "Applying League of Legends wine prefix registry settings."
echo "*************************************************"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX=/home/$USER/League\ of\ Legends wine regedit /S lol.reg


echo "*************************************************"
echo "Installing League of Legends."
echo "*************************************************"
wget https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20NA.exe

WINEDEBUG=-all WINEARCH=win32 WINEPREFIX=/home/$USER/League\ of\ Legends wine League\ of\ Legends\ installer\ NA.exe

echo "*************************************************"
echo "Creating League of Legends shell script"
echo "*************************************************"

echo "#!/bin/bash" > leagueoflegends.sh
echo "WINEARCH=win32 WINEPREFIX=/home/$USER/League\ of\ Legends WINEDEBUG=-all wine /home/$USER/League\ of\ Legends/drive_c/Riot\ Games/League\ of\ Legends/LeagueClient.exe" >> leagueoflegends.sh

chmod a+x leagueoflegends.sh

echo "*************************************************"
echo "The next few steps will prompt you for shortcut creations. If root is required, please enter your root password when prompted."
echo "*************************************************"

echo "*************************************************"
echo "Creating League of Legends shell script."
echo "*************************************************"
sudo cp leagueoflegends.sh /usr/bin/leagueoflegends


read -p "Would you like a menu shortcut? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

	echo "*************************************************"
	echo "Creating League of Legends application menu shortcut."
	echo "*************************************************"

	sudo cp /home/$USER/League\ of\ Legends/drive_c/Riot\ Games/League\ of\ Legends/RADS/system/icon.ico /usr/share/pixmaps/

	echo "[Desktop Entry]" > leagueoflegends.desktop
	echo "Encoding=UTF-8" >> leagueoflegends.desktop
	echo "Name=League of Legends" >> leagueoflegends.desktop
	echo "GenericName=League of Legends" >> leagueoflegends.desktop
	echo "League of Legends" >> leagueoflegends.desktop
	echo "Exec=/usr/bin/leagueoflegends \"\$@\"" >> leagueoflegends.desktop
	echo "Icon=/usr/share/pixmaps/icon.ico" >> leagueoflegends.desktop
	echo "StartupNotify=true" >> leagueoflegends.desktop
	echo "Terminal=false" >> leagueoflegends.desktop
	echo "Type=Application" >> leagueoflegends.desktop
	echo "Categories=Application;Game" >> leagueoflegends.desktop

	sudo cp leagueoflegends.desktop /usr/share/applications/
fi

read -p "Would you like a desktop shortcut? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "*************************************************"
	echo "Creating League of Legends desktop shortcut."
	echo "*************************************************"
	cp /usr/share/applications/leagueoflegends.desktop /home/$USER/Desktop/
fi


echo "*************************************************"
echo "Installation complete! It is safe to delete this folder."
echo "*************************************************"