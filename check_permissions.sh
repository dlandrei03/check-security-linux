#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

sleep 1
echo "Checking permissions..."
sleep 1

fileProblemUID=$(sudo find / -type f -perm -4000 -print 2>/dev/null)
fileProblemGID=$(sudo find / -type f -perm -2000 -print 2>/dev/null)

# Verificam probleme ce pot aparea (UID sau GID nu sunt root sau un utilizatori de incredere)

fixProblemUID()
{
    local file=$1

    sudo chmod o-x $file
    echo -e "\e[32mFile has no longer right to be executed by anyone!\e[0m"
}

fixProblemGID()
{
    local file=$1

    sudo chmod g-x $file
    echo -e "\e[32mFile has no longer right to be executed by any group!\e[0m"
}

problemFileUID()
{
    local file=$1

    local uid=$(ls -l $file | cut -d" " -f3)

    local allexecute=$(ls -l $file | cut -c10)
    if [[ $allexecute == 'x' ]]
    then
        echo -e "\e[31mFile $file can be executed by anybody and has SUID setted!\e[0m"
    fi

    echo -e "\e[33mDo you want to change the executable for others to none?(y/n)"
    read answer
    if [[ $answer == 'y' ]]
    then
        fixProblemUID $file
    fi
}

problemFileGID()
{
    local file=$1

    local uid=$(ls -l $file | cut -d" " -f3)

    local allexecute=$(ls -l $file | cut -c7)
    if [[ $allexecute == 'x' ]]
    then
        echo -e "\e[31mFile $file can be executed by anybody and has GUID setted!\e[0m"
    fi

    echo -e "\e[33mDo you want to change the executable for groups to none?(y/n)"
    read answer
    if [[ $answer == 'y' ]]
    then
        fixProblemGID $file
    fi
}

for file1 in $fileProblemUID
do
    if test -x $file1
    then
        problemFileUID $file1
    fi
done

echo 
echo "##############################"
echo 

for file2 in $fileProblemGID
do
    if test -x $file2
    then
        problemFileGID $file2
    fi
done