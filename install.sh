#!/bin/bash
# Some global WINE configuration variable exports.
# WINEPREFIX can be passed via environment to override the default.
# To do this, run this script with "WINEPREFIX=..." in front of the command:
# $ WINEPREFIX=$HOME/.wineprefix/LoL ./install.sh
export WINEARCH=win32
export WINEDEBUG=-all
export WINEPREFIX=${WINEPREFIX:-"$HOME/.wineprefix/LoL"}
echo "************************************************"
echo "Installing winetricks"
echo "************************************************"
curl -o /home/deck/wine-lol/winetricks http://winetricks.org/winetricks 
chmod +x /home/deck/wine-lol/winetricks

mkdir -p "$WINEPREFIX"

echo "*************************************************"
echo "Creating wine prefix and performing winetricks."
echo "*************************************************"

/home/deck/wine-lol/winetricks -q d3dx9

echo "*************************************************"
echo "Applying League of Legends wine prefix registry settings."
echo "*************************************************"
/home/deck/wine-lol/bin/wine regedit /S lol.reg


echo "*************************************************"
echo "Installing League of Legends. !!!Please do not launch the game!!!"
echo "*************************************************"

curl -o live.na.exe https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.na.exe 
/home/deck/wine-lol/bin/wine live.na.exe 'League of Legends installer NA.exe'

# TODO: The installer will create shortcuts (or better wine will create them)
#       - Locate these .desktop files
#       - Delete them

echo "*************************************************"
echo "The next few steps will prompt you for shortcut creations."
echo "*************************************************"

echo "*************************************************"
echo "Creating League of Legends shell script"
echo "*************************************************"

# copy icon to $HOME/.local/share/icons/
cp $WINEPREFIX/drive_c/ProgramData/Riot\ Games/Metadata/league_of_legends.live/league_of_legends.live.ico $HOME/.local/share/icons/lol.ico

# This is the "user local" BIN-directory for many distributions
mkdir -p "$HOME/bin"

echo "#!/bin/bash" > leagueoflegends.sh
echo "export __GL_THREADED_OPTIMIZATIONS=1" >> leagueoflegends.sh
echo "export MESA_GLTHREAD=TRUE" >> leagueoflegends.sh
echo "export GPU_MAX_HEAP_SIZE=100" >> leagueoflegends.sh
echo "export GPU_MAX_ALLOC_PERCENT=100" >> leagueoflegends.sh
echo "bash $HOME/bin/lol-launchhelper &" >> leagueoflegends.sh
echo "WINEARCH=win32 WINEPREFIX=\"$WINEPREFIX\" WINEDEBUG=-all /home/deck/wine-lol/bin/wine \"C:/Riot Games/League of Legends/LeagueClient.exe\"" >> leagueoflegends.sh

chmod a+x leagueoflegends.sh
cp leagueoflegends.sh "$HOME/bin/leagueoflegends"
cp lol-launchhelper.sh "$HOME/bin/lol-launchhelper"

echo "*************************************************"
echo "Generating League of Legends .desktop file"
echo "*************************************************"

echo "[Desktop Entry]" > leagueoflegends.desktop
echo "Encoding=UTF-8" >> leagueoflegends.desktop
echo "Name=League of Legends" >> leagueoflegends.desktop
echo "GenericName=League of Legends" >> leagueoflegends.desktop
echo "Exec=$HOME/bin/leagueoflegends \"\$@\"" >> leagueoflegends.desktop
echo "Icon=$HOME/.local/share/icons/lol.ico" >> leagueoflegends.desktop
echo "StartupNotify=true" >> leagueoflegends.desktop
echo "Terminal=false" >> leagueoflegends.desktop
echo "Type=Application" >> leagueoflegends.desktop
echo "Categories=Application;Game" >> leagueoflegends.desktop
echo "StartupWMClass=leagueclientux.exe" >> leagueoflegends.desktop


read -p "Would you like a menu shortcut? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "*************************************************"
	echo "Creating League of Legends application menu shortcut."
	echo "*************************************************"
	cp leagueoflegends.desktop "$HOME/.local/share/applications/"
	update-desktop-database "$HOME/.local/share/applications"
fi

read -p "Would you like a desktop shortcut? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "*************************************************"
	echo "Creating League of Legends desktop shortcut."
	echo "*************************************************"
	DESKTOP_PATH=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
	cp leagueoflegends.desktop "$DESKTOP_PATH"
fi


echo "*************************************************"
echo "Installation complete! It is safe to delete this folder."
echo "*************************************************"
