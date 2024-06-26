#!/bin/bash

logFile=/var/log/csl

if [[ ! -e $logFile ]]
then
    sudo mkdir -p $logFile
    echo "[MAIN] Directorul $logFile a fost creeat!"
fi

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

echo "Starting check_processes.sh..."
sleep 1

if test -f check_processes.sh
then
    sudo bash check_processes.sh
else
    sudo "File check_processes.sh doesn't exist!..."
fi

echo "Starting check_packets.sh..."
sleep 1

if test -f check_packets.sh
then
    sudo bash check_packets.sh
else
    sudo "File check_packets.sh doesn't exist!..."
fi

echo "Starting check_controlsum.sh..."
sleep 1

if test -f check_controlsum.sh
then
    sudo bash check_controlsum.sh
else
    sudo "File check_controlsum.sh doesn't exist!..."
fi

sleep 1

echo "Security checks completed!"

echo "##############################"