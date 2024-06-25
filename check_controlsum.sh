#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

# Database control sum
controlfile=/var/log/csl/controlfile
diffFile=/var/log/csl/diff

packages=$(dpkg-query -W -f='${binary:Package}\n')

# Generarea directorului controlfile cu fisierele (sume de control) pentru fiecare pachet
if [[ ! -e $controlfile ]]
then
    # Creeam fisierul pentru sume

    sudo mkdir $controlfile
    echo "Generating SHA256 checksums for each package's files..."

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

echo "Do you want to check every packet control sum?(y/n)"
read answer

if [[ $answer == 'y' || $answer == 'Y' ]]
then
    echo "Calculating packages control sum..."

    for pkg in $packages
    do

        files=$(dpkg -L "$pkg")
        
        checksum_file_old="$controlfile/${pkg}_checksums"
        checksum_file_new="$controlfile/${pkg}_checksumsNew"

        for file in $files
        do
            if [ -f "$file" ]; then
            sha256sum "$file" >> "$checksum_file_new"
            fi
        done

        if [[ -e $diffFile ]]
        then
            >$diffFile
        fi

        if [[ -e $checksum_file_old && -e $checksum_file_new ]]
        then
            diff $checksum_file_old $checksum_file_new > $diffFile
        else
            continue
        fi

        if [[ -s $diffFile ]]
        then
            echo "Problem checksum control for $pkg!"
            sudo rm $diffFile
        fi
        sudo rm $checksum_file_new

    done

fi