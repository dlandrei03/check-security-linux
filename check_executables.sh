#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo -e "\e[33m[EXECUTABLES] Searching for executable files without rights of execution...\e[0m"

execFile=/var/log/csl/executable.log

if [[ ! -e $execFile ]]
then
    sudo touch $execFile
else
    sudo rm $execFile
    sudo touch $execFile
fi

binaries="/bin
          /sbin
          /usr/bin
          /usr/sbin
          /usr/local/bin
          /usr/local/sbin
          /snap/bin
          "

nonExecutableFile ()
{
    local file=$1

    if test -f $file
    then
        echo "[EXECUTABLES] A problem was detected in $binary"
        echo -e "\e[31m[EXECUTABLES] File $file is non-executable!\e[0m"
        sudo ls -ld $file

        echo "[EXECUTABLES] Do you want to make this file executable?(y/n)"
        read answer
        if [[ $answer == 'y' ]]
        then
            sudo chmod +x $file
            echo -e "\e[32m[EXECUTABLES] Fisierul a fost modificat si are drept de executie!\e[0m"
            sleep 1
            return 0
        fi

        echo "[EXECUTABLES] Do you want to delete this file?(y/n)"
        read answer
        if [[ $answer == 'y' ]]
        then
            sudo rm -f $file
            echo -e "\e[32m[EXECUTABLES] File deleted!\e[0m"
            sleep 1
            return 0
        fi

        echo "$file is non executable!" >> $execFile
        return 1
    fi
}

for binary in $binaries
do
    fileProblem=$(sudo find "$binary" -type f ! -executable -print 2>/dev/null)
    
    if [[ -z $fileProblem ]]
    then
        echo "$binary is safe!" >> $execFile
        continue
    else
        echo "[WARNING] $binary: " >> $execFile
    fi

    for filep in $fileProblem
    do
        nonExecutableFile $filep
    done
done

echo "[EXECUTABLES] Log file is at $execFile"