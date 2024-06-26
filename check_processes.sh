#!/bin/bash

# Verificarea proceselor potential daunatoare intr-un linux

echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

echo -e "\e[33m[PROCESSES] Check processes\e[0m"

processFile=/var/log/csl/process.log
database=/var/log/csl/process.db

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

verifyDatabase()
{
    local cpid=$1

    local pname=$(ps -p $cpid | tail -1 | tr -s " " | cut -d" " -f 5-)
    if sudo grep -q "$pname" "$database"
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
    echo "[PROCESSES] Do you want to add this child process as safe in database?(y/n)"
    read answer </dev/tty

    if [[ $answer == 'y' || $answer == 'Y' ]]
    then
        local pname=$(ps -p $cpid | tail -1 | tr -s " " | cut -d" " -f 5-)
        sudo echo $pname >> $database
        return 0
    fi
    return 1
}

killProcess()
{
    local pid=$1
    local pname=$(ps -p $pid | tail -1 | tr -s " " | cut -d" " -f 5-)
    pkill -9 $pid
    kill $pid

    echo "[PROCESSES] Process with pid: $pid terminated: ($pname)"
}

problem=$(echo "0")

# Procese consumatoare de CPU, MEM si care apartin altor utilizatori fata de cei trusted
ps aux --sort=-%mem | awk 'NR>1{print $1, $2, $3, $4, $11}' | while read user pid cpu mem command
do
    # Verificam daca sunt procese ce folosesc mai mult de 10% din CPU
    if (( $(echo "$cpu > 10.0" | bc -l) ))
    then
        problem=$(echo "0")
        childs=$(pgrep -P $pid | tr -s "\n" " ")
        for process in $childs
        do
            if ! verifyDatabase $process
            then
                if ! verifyChild $process
                then
                    problem=$(echo "1")
                fi
            fi
        done
        if [[ $problem == "1" ]]
        then
            echo "[PROCESSES] Process $command uses more than 10% of CPU: $cpu"
            echo "Process $command uses more than 10% of CPU: $cpu" >> $processFile

            echo "Do you want to kill this process?(y/n)"
            read answer </dev/tty
            if [[ $answer == "y" || $answer == "Y" ]]
            then
                killProcess $pid
                continue
            fi
        fi
    fi

    # Verificam daca sunt procese ce folosesc mai mutl de 10% din memorie
    if (( $(echo "$mem > 10.0" | bc -l) ))
    then
        problem=$(echo "0")
        childs=$(pgrep -P $pid | tr -s "\n" " ")
        for process in $childs
        do
            if ! verifyDatabase $process
            then
                if ! verifyChild $process
                then
                    problem=$(echo "1")
                fi
            fi
        done
        
        # Verificam daca s-au gasit probleme
        if [[ $problem == "1" ]]
        then
            echo "[PROCESSES] Process $command uses more than 10% of memory: $mem."
            echo "Process $command uses more than 10% of memory: $mem." >> $processFile

            echo "Do you want to kill this process?(y/n)"
            read answer </dev/tty
            if [[ $answer == "y" || $answer == "Y" ]]
            then
                killProcess $pid
            fi
        fi
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
                echo "[PROCESSES] Process $proc (PID $pid) with parent $parent_comm (PPID $ppid), expected $expected_parent (default)."
                echo "Process $proc (PID $pid) with parent $parent_comm (PPID $ppid), expected $expected_parent (default)." >>$processFile
            fi
        fi
    done < /tmp/proc_list
done

rm /tmp/proc_list

echo "[PROCESS] Fisierul cu report se gaseste in $processFile"