#!/bin/bash

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo -e "\e[33m[PERMISSIONS] Checking permissions...\e[0m"

dataBase=/var/log/csl/permissions.log

if [[ -e $dataBase ]]
then
    echo "[PERMISSIONS] Loading database..."
    sleep 1
    echo "[PERMISSIONS] Database loaded!"
else
    touch $dataBase
fi

echo "[PERMISSIONS] Finding files with SUID and SGID set..."
# Fisiere cu SUID si SGID setate
fileWithUID=$(sudo find / -type f -perm -u=s -print 2>/dev/null)
fileWithGID=$(sudo find / -type f -perm -g=s -print 2>/dev/null)

sudoUsers=$(sudo cat /etc/group | grep sudo | cut -d: -f4 | tr -s "," " ")

# Scoatem dreptul de executabil/ lasam la alegerea user-ului
solveProblem()
{
    local fisier=$1

    echo "[PERMISSIONS] Do you want to make $fisier non-executable by others?(y/n)"
    read answer

    # Daca raspunsul este da, modificam fisierul a.i. sa nu mai fie executat de oricine cu drepturi su
    if [[ $answer == 'y' || $answer == 'Y' ]]
    then
        sudo chmod o-x $fisier
        echo "[PERMISSIONS] File can no longer be executed by others!"
        return 0
    else
        # Salvam raspunsul in baza de date
        echo $fisier >>$dataBase
        echo "[PERMISSIONS] Answer saved in database"
        return 0
    fi

    return 1
}

checkDatabaseOption()
{
    local file=$1

    # Verificam daca acesta exista in baza de date
    if grep -q "$file" "$dataBase"
    then
        return 0
    fi
    return 1
}

# Verificam daca oricine poate executa acest fisier cu SUID/SGID setat
checkExecutableByAny()
{
    local fisier=$1

    # Drept de executie by others
    local perm=$(sudo stat -c %A check_permissions.sh | cut -c10)

    # Daca nu poate fi executat de others, iesim
    if [[ $perm != 'x' ]]
    then
        return 0
    fi

    # SUID
    if [[ $2 == "1" ]]
    then
        # Verificam cine detine fisierul (root sau alti utilizatori cu drepturi de sudo)
        local own=$(sudo stat -c %U $fisier)
    else
        local own=$(sudo stat -c %G $fisier)
    fi

    if [[ $own == "root" ]]
    then
        if ! checkDatabaseOption $fisier
        then
            solveProblem $fisier
        fi
        return 0
    fi

    for usOw in $sudoUsers
    do
        # Other sudoers
        if [[ $own == $usOw ]]
        then
            if ! checkDatabaseOption $fisier
            then
                solveProblem $fisier
            fi
            return 0
        fi
    done
}

suid=$(echo "1")
sgid=$(echo "2")

for file in $fileWithUID
do
    checkExecutableByAny $file $suid
done

for file in $fileWithGID
do
    checkExecutableByAny $file $sgid
done

echo "[PERMISSIONS] Permissions check done!"
echo "[PERMISSIONS] Log file is in: $dataBase!"