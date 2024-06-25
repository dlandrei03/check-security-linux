#!/bin/bash

# Verificarea proceselor potential daunatoare intr-un linux

processFile=/var/log/csl/processfile
database=/var/log/csl/processdatabase

if [[ ! -e $database ]]
then
    sudo touch $database
fi

if [[ -e $processFile ]]
then
    sudo rm $processFile
    sudo touch $processFile
else
    sudo touch $processFile
fi


echo "Check processes"
echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

verifyDatabase()
{
    local cpid=$1

    local pname=$(ps -p 2241 | tail -1 | tr -s " " | cut -d" " -f 5-)
    if grep -q "$pname" "$database"
    then
        return 0
    fi
    return 1
}

verifyChild()
{
    local cpid=$1
    echo 
    echo "####################"
    echo 
    ps -p $cpid
    echo "Do you want to add this child process as safe in database?(y/n)"
    read answer </dev/tty

    if [[ $answer == 'y' || $answer == 'Y' ]]
    then
        local pname=$(ps -p 2241 | tail -1 | tr -s " " | cut -d" " -f 5-)
        echo $pname >> $database
        return 0
    fi
    return 1
}

# Procese consumatoare de CPU, MEM si care apartin altor utilizatori fata de cei trusted
ps aux --sort=-%mem | awk 'NR>1{print $1, $2, $3, $4, $11}' | while read user pid cpu mem command
do
    # Verificam daca sunt procese ce folosesc mai mult de 10% din CPU
    if (( $(echo "$cpu > 10.0" | bc -l) ))
    then
        echo "Alert: Procesul $command foloseste peste 10% din CPU: $cpu%."
        echo "Alert: Procesul $command foloseste peste 10% din CPU: $cpu%." >> $processFile

        childs=$(pgrep -P $pid | tr -s "\n" " ")
        for process in $childs
        do
            if ! verifyDatabase $process
            then
                if ! verifyChild $process
                then
                    echo "Alert: Procesul $command foloseste peste 10% din memorie: $mem% (UNSAFE)."
                    echo "Alert: Procesul $command foloseste peste 10% din memorie: $mem% (UNSAFE)." >> $processFile
                fi
            fi
        done
    fi

    # Verificam daca sunt procese ce folosesc mai mutl de 10% din memorie
    if (( $(echo "$mem > 10.0" | bc -l) ))
    then
        childs=$(pgrep -P $pid | tr -s "\n" " ")
        for process in $childs
        do
            if ! verifyDatabase $process
            then
                if ! verifyChild $process
                then
                    echo "Alert: Procesul $command foloseste peste 10% din memorie: $mem% (UNSAFE)."
                    echo "Alert: Procesul $command foloseste peste 10% din memorie: $mem% (UNSAFE)." >> $processFile
                fi
            fi
        done
    fi
done

#3 Verificare procese parinte
declare -A processes
processes=(
    ["sshd"]="init"
    ["cron"]="init"
    ["nginx"]="init"
    ["mysql"]="init"
    ["postgres"]="init"
    ["docker"]="init"
    ["cron"]="init"
)

ps -eo pid,ppid,comm --sort=ppid > /tmp/proc_list

for proc in ${!processes[@]}; do
    expected_parent=${processes[$proc]}
    
    while read -r pid ppid comm; do
        if [[ $comm == $proc ]]; then
            parent_comm=$(ps -p $ppid -o comm=)
            if [[ $parent_comm != $expected_parent && $parent_comm != "systemd" ]]
            then
                echo "Alert: Procesul $proc (PID $pid) are ca parinte pe $parent_comm (PPID $ppid), nu $expected_parent (default)." >> $processFile
                echo "Alert: Procesul $proc (PID $pid) are ca parinte pe $parent_comm (PPID $ppid), nu $expected_parent (default)."
            fi
        fi
    done < /tmp/proc_list
done

rm /tmp/proc_list

echo "Fisierul cu report se gaseste in $processFile"