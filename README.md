# check-security-linux
#### Script pentru detectia riscurilor de securitate in linux. [main](script)  
Utilitati:  
1. Verificare executabile, permisiuni [script1] [script2]
2. Verificare procese [script3]
3. Verificare versiuni pachete, verificare sume de control [script4]

# 17.06.2024
Am ales tema

# 18.06.2024
#### Documentatie
M-am documentat cu privire la ceea ce trebuie facut la acest script  
[linuxmint](https://forums.linuxmint.com/viewtopic.php?t=359105) - Verificare fisiere corupte  
[askubuntu](https://askubuntu.com/questions/221385/how-to-find-which-package-can-be-updated) - Lista pachete vechi ce pot fi updatate  
[javatpoint](https://www.javatpoint.com/linux-file-system - Sistemul de partitionare al linux-ului), pentru aflarea executabilelor  
[linkedin](https://www.linkedin.com/advice/3/what-implications-setting-suid-sgid-sticky-abvde) - probleme legate de securitate (sgid, suid) user group permissions pentru executabile  

# 19.06.2024
#### Readme
Cum se face un README.md bun.  
[medium](https://medium.com/@saumya.ranjan/how-to-write-a-readme-md-file-markdown-file-20cb7cbcd6f)  
[markdowntutorial](https://www.markdowntutorial.com/)

### Construirea script-urilor pentru gestionarea problemelor de securitate din cadrul unui linux.  
Script  
Contine:  
* check_executables.sh
* check_permissions.sh
* check_processees.sh
* check_packets.sh
* check_controlsum.sh

Executarea script-urilor pentru gestionarea problemelor de securitate  
check_executables.sh - Verificarea dreptului de executie al fisierelor  
