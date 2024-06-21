#!/bin/bash

# Verificarea proceselor potential daunatoare intr-un linux

processFile=/var/log/processFile

if [[ -e $processFile ]]
then
    rm $processFile
fi

echo "Check processes"
echo 
echo "##############################"
echo "##############################"
echo "##############################"
echo 

#1 Procese care consuma cea mai multa memorie
echo "Procese consumatoare de memorie:" >> $processFile
ps aux --sort=-%mem | head >> $processFile

#2 Procese care consuma CPU
echo "Procese consumatoare de CPU:" >> $processFile
ps aux --sort=-%cpu | head >> $processFile

#dependencies, verificare cine a lansat anumite procese in executie (pid)
#creearea unei baze de date pentru procesele comune si verificare pentru lansari ale altor procese

#3 Verificare procese parinte
declare -A processes
processes=(
    ["sshd"]="init"
    ["cron"]="init"
    ["nginx"]="init"
    ["mysql"]="init"
)

ps -eo pid,ppid,comm --sort=ppid > /tmp/proc_list

for proc in "${!processes[@]}"; do
    expected_parent="${processes[$proc]}"
    
    while read -r pid ppid comm; do
        if [[ "$comm" == "$proc" ]]; then
            parent_comm=$(ps -p $ppid -o comm=)
            if [[ "$parent_comm" != "$expected_parent" ]]; then
                echo "Alert: Procesul $proc (PID $pid) are ca parinte pe $parent_comm (PPID $ppid), dar se astepta $expected_parent." >> $processFile
                echo "Alert: Procesul $proc (PID $pid) are ca parinte pe $parent_comm (PPID $ppid), dar se astepta $expected_parent."
            fi
        fi
    done < /tmp/proc_list
done

rm /tmp/proc_list

echo "Fisierul cu report se gaseste in /var/log/processFile"