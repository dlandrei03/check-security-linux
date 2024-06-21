#!/bin/bash

echo -e "\e[32m##############################"
echo "#                            #"
echo "#                            #"
echo "#                            #"
echo "#       SECURITY-CHECK       #"
echo "#                            #"
echo "#                            #"
echo "#                       DINU #"
echo -e "##############################\e[0m"

sleep 1
echo .
sleep 1
echo ..
sleep 1
echo ...
sleep 1

echo "Starting security checks..."

echo "Starting check_executables.sh..."
sleep 1

if test -f check_executables.sh
then
    sudo bash check_executables.sh
else
    sudo "File check_executables.sh doesn't exist!..."
fi

echo "Starting check_permissions.sh..."
sleep 1

if test -f check_permissions.sh
then
    sudo bash check_permissions.sh
else
    sudo "File check_permissions.sh doesn't exist!..."
fi

sleep 1

echo "Security checks completed!"

echo "##############################"