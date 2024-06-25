#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo "Checking packages..."

# Verificare updatare pachete (versiune)
dpkg-query -W -f='${binary:Package} ${Version}\n' | while read -r pkg installed_version
do
    latest_version=$(apt-cache policy "$pkg" | grep Candidate | awk '{print $2}')
    if [[ $installed_version != $latest_version ]]
    then
        echo "Pachetul $pkg nu este actualizat: [WARNING]$installed_version - $latest_version"
        echo "Do you want to update it?(y/n)" 
        read answer </dev/tty

        if [[ $answer == 'y' || $answer == 'Y' ]]
        then
            sudo apt install --only-upgrade $pkg 2>/dev/null
            echo "Pachetul a fost updatat!"
        fi
    fi
done