#!/bin/bash

echo "Searching for executable files without rights of execution..."

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
        echo "A problem was detected in $binary"
        echo -e "\e[31mFile $file is non-executable!\e[0m"
        sudo ls -ld $file
        echo
        echo "##############################"
        echo
        echo "Do you want to delete this file?(y/n)"
        read answer
        if [[ $answer == 'y' ]]
        then
            sudo rm -f $file
            echo -e "\e[32mFisierul a fost stres!\e[0m"
            echo "##############################"
            sleep 1
            return 0
        fi

        echo "Do you want to make this file executable?(y/n)"
        read answer2
        if [[ $answer2 == 'y' ]]
        then
            sudo chmod +x $file
            echo -e "\e[32mFisierul a fost modificat si are drept de executie!\e[0m"
            echo "##############################"
            sleep 1
            return 0
        fi
        return 1
    fi
}

for binary in $binaries
do
    echo 
    echo "##############################"
    echo 

    fileProblem=$(sudo find "$binary" -type f ! -executable -print 2>/dev/null)
    
    if [[ -z $fileProblem ]]
    then
        echo "$binary is safe!"
        continue
    fi

    for filep in $fileProblem
    do
        nonExecutableFile $filep
    done
done