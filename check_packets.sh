#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo -e "\e[33m[PACKETS] Checking packages...\e[0m"

logfile=/var/log/csl/packets.log

if [[ -e $logfile ]]
then
    sudo rm $logfile
    sudo touch $logfile
else
    sudo touch $logfile
fi

# Verificare updatare pachete (versiune)
dpkg-query -W -f='${binary:Package} ${Version}\n' | while read -r pkg installed_version
do
    latest_version=$(apt-cache policy "$pkg" | grep Candidate | awk '{print $2}')
    if [[ $installed_version != $latest_version ]]
    then
        echo "[PACKETS] Package $pkg is not updated: [WARNING] $installed_version - $latest_version"
        echo "[PACKETS] Do you want to update it?(y/n)" 
        read answer </dev/tty

        if [[ $answer == 'y' || $answer == 'Y' ]]
        then
            sudo apt install --only-upgrade $pkg 2>/dev/null
            echo "[PACKETS] Package updated!"
        else
            echo "[WARNING] $installed_version - $latest_version" >$logfile
        fi
    fi
done