#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo -e "\e[33m[CONTROL] Control sum...\e[0m"

# Database control sum
controlfile=/var/log/csl/controlfile
diffFile=/var/log/csl/diff
logfile=/var/log/csl/controlsum.log

if [[ -e $logfile ]]
then
    sudo rm $logfile
    sudo touch $logfile
else
    sudo touch $logfile
fi

packages=$(dpkg-query -W -f='${binary:Package}\n')

# Generarea directorului controlfile cu fisierele (sume de control) pentru fiecare pachet
if [[ ! -e $controlfile ]]
then
    # Creeam fisierul pentru sume

    sudo mkdir $controlfile
    echo "[CONTROL] Generating SHA256 checksums for each package's files..."

    for pkg in $packages
    do

        files=$(dpkg -L "$pkg")
        checksum_file="$controlfile/${pkg}_checksums"

        for file in $files
        do
            if [ -f "$file" ]; then
            sha256sum "$file" >> "$checksum_file"
            fi
        done

    done
fi

echo "[CONTROL] Do you want to check every packet control sum?(y/n)"
read answer

if [[ $answer == 'y' || $answer == 'Y' ]]
then
    echo "[CONTROL] Calculating packages control sum..."

    for pkg in $packages
    do

        files=$(dpkg -L "$pkg")
        
        checksum_file_old="${controlfile}/${pkg}_checksums"
        checksum_file_new="${controlfile}/${pkg}_checksumsNew"

        for file in $files
        do
            if [ -f $file ]
            then
                sha256sum $file >> $checksum_file_new
            fi
        done

        diff $checksum_file_old $checksum_file_new > $diffFile

        if [[ -s $diffFile ]]
        then
            echo "[CONTROL] Problem checksum control for $pkg!"
            sudo rm $diffFile

            echo "[CONTROL] Do you want to update the sum control for $pkg?(y/n)"
            read answer

            if [[ $answer == 'y' || $answer == 'Y' ]]
            then
                sudo rm $checksum_file_old
                sudo cp $checksum_file_new "${controlfile}/${pkg}_checksums"
                echo "[CONTROL] Sum control for $pkg has been updated!"
            else
                echo "[CONTROL] Problem checksum control for $pkg!" > $logfile
            fi
        fi
        sudo rm $checksum_file_new 

    done

fi