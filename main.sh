#!/bin/bash

echo "##############################"
echo "#                            #"
echo "#                            #"
echo "#                            #"
echo "#       SECURITY-CHECK       #"
echo "#                            #"
echo "#                            #"
echo "#                       DINU #"
echo "##############################"

sleep 1
echo .
sleep 1
echo ..
sleep 1
echo ...
sleep 1

echo "Starting security checks..."

if test -f check_executables.sh
then
    sudo bash check_executables.sh
else
    sudo "File check_executables.sh doesn't exist!..."
fi

sleep 1

echo "Security checks completed!"

echo "##############################"