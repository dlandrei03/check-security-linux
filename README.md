# check-security-linux
#### Script pentru detectia riscurilor de securitate in linux. [script principal](#script)  
Utilitati:  
1. Verificare executabile, permisiuni [check_executables.sh](#script-executables) [check_permissions.sh](#script-permissions)
2. Verificare procese (#script-executables)[check_processees.sh]
3. Verificare versiuni pachete, verificare sume de control [check_packets.sh] [check_controlsum.sh]

# 17.06.2024
### Tema
#### Script pentru detectia riscurilor de securitate intr-un sistem linux
* Verificare executabile, permisiuni
* Verificare procese
* Verificare versiuni pachete, verificare sume de control

# 18.06.2024
### Documentatie
#### Documentatie privind informatiile necesare pentru creearea scriptului:
1. Verificare fisiere corupte: [linuxmint](https://forums.linuxmint.com/viewtopic.php?t=359105)  
2. Lista pachete vechi ce pot fi updatate: [askubuntu](https://askubuntu.com/questions/221385/how-to-find-which-package-can-be-updated)  
3. Sistemul de partitionare al linux-ului, pentru aflarea executabilelor: [javatpoint](https://www.javatpoint.com/linux-file-system)  
4. Probleme legate de securitate (sgid, suid) user group permissions pentru executabile: [linkedin](https://www.linkedin.com/advice/3/what-implications-setting-suid-sgid-sticky-abvde)

# 19.06.2024
### Readme
#### Cum se face un README.md bun.  
* [Tutorial](https://medium.com/@saumya.ranjan/how-to-write-a-readme-md-file-markdown-file-20cb7cbcd6f)  
* [Tutorial interactiv](https://www.markdowntutorial.com/)
* [Prezentare](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/)

### Construirea script-urilor pentru gestionarea problemelor de securitate din cadrul unui linux.  
#### Script principal
<a name="script"></a>
Contine:  
* [check_executables.sh](#script-executables)
* [check_permissions.sh](#script-permissions)
* [check_processees.sh](#script-executables)
* check_packets.sh
* check_controlsum.sh

Executarea script-urilor pentru gestionarea problemelor de securitate

## check_executables.sh
<a name="script-executables"></a>
### Continut:
* Cautarea in directoarele in care se afla fisierele binare
* Gasirea celor neexecutabile
* Stergerea la alegerea utilizatorului
* Modificarea acestuia in executabil

## check_permissions.sh
<a name="script-permissions"></a>
### Continut:
* Cautarea fisierelor ce au SUID sau GUID setat, executabile
* Gestionarea acestora pentru a nu putea fi executate de oricine, la alegerea utilizatorului

## check_processes.sh
<a name="script-processes"></a>
### Documentatie:
* [Antivirus](https://www.linkedin.com/advice/3/what-best-ways-troubleshoot-linux-system-5z1tc) pentru linux (chkrootkit)
* [Chkrootkit](https://www.kali.org/tools/chkrootkit/) utilizari

### Continut:
* Cauta procesele ce ruleaza pe sistem ce folosesc cel mai mare procentaj de memorie si CPU
* Verifica procesele importante sshd, cron etc sa fie lansate de init

# 21.06.2024
* Verificarea proceselor (parinti) sa fie cei asteptati
* Atentionarea utilizatorului printr-un warning in cazul in care parintele nu este cel asteptat