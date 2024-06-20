#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

sleep 1
echo "Checking permissions..."
sleep 1

fileProblemUID=$(sudo find /home/student -type f -perm -u=s -print 2>/dev/null)
fileProblemGID=$(sudo find / -type f -perm -g=s -print 2>/dev/null)

# Verificam probleme ce pot aparea (UID sau GID nu sunt root sau nu utilizatori de incredere)

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

    local uid=$(sudo ls -l $file | cut -d" " -f3)

    echo "Checking UID for file $file: $uid"

    if [[ $uid == "root" ]]
    then
        return 0
    fi

    echo -e "\e[33mDo you want to change the executable for others to none?(y/n)\e[0m"
    read answer
    if [[ $answer == 'y' ]]
    then
        fixProblemUID $file
    fi
}

problemFileGID()
{
    local file=$1

    local gid=$(sudo ls -l $file | cut -d" " -f4)

    echo "Checking GID for file $file: $gid"
    if [[ $gid == "root" ]]
    then
        return 0
    fi

    echo -e "\e[33mDo you want to change the executable for groups to none?(y/n)\e[0m"
    read answer
    if [[ $answer == 'y' ]]
    then
        fixProblemGID $file
    fi
}

for file1 in $fileProblemUID
do
    if sudo test -x $file1 && sudo test -e $file1
    then
        problemFileUID $file1
    fi
done

echo 
echo "##############################"
echo 

for file2 in $fileProblemGID
do
    if sudo test -x $file2 && sudo test -e $file2
    then
        problemFileGID $file2
    fi
done