#!/bin/bash

echo "Searching for executable files without rights of execution..."

binaries="/bin 
          /sbin 
          /usr/bin 
          /usr/sbin 
          /usr/local/bin 
          /usr/local/sbin
          /opt
          /snap/bin
          /var/lib/flatpak/exports/bin
          "

nonExecutableFile ()
{
    local file=$1

    if test -f $file
    then
        echo "A problem was detected in $binary"
        echo "File $file is non-executable!"
        echo
        echo "##############################"
        echo
        echo "Do you want to delete this file?(y/n)"
        read answer
        if [[ answer == 'y' ]]
        then
            sudo rm -f $file
        fi
    fi
}

for binary in $binaries
do
    echo 
    echo "##############################"
    echo 

    fileProblem=$(find "$binary" -type f ! -executable -print)
    
    if [[ -z $fileProblem ]]
    then
        echo "$binary is safe!"
        continue
    fi

    nonExecutableFile $fileProblem
done