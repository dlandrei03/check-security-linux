# Script pentru Detectia Riscurilor de Securitate intr-un Sistem Linux

### Table Of Content
- [Descriere](#descriere)
- [Functionalitati](#functionalitati)
- [Structura Proiectului](#structura-proiectului)
- [Utilizare](#utilizare)
- [Detalii Scripturi](#detalii-scripturi)
    - [main.sh](#mainsh)
    - [check_executables.sh](#check_executablessh)
    - [check_permissions.sh](#check_permissionssh)
    - [check_processes.sh](#check_processessh)
    - [check_packets.sh](#check_packetssh)
    - [check_controlsum.sh](#check_controlsumsh)
- [Documentatie](#documentatie)

### Descriere
Acest proiect contine scripturi pentru detectia riscurilor de securitate intr-un sistem Linux. Scripturile verifica executabilele, permisiunile, procesele, versiunile pachetelor si sumele de control, pentru a asigura o mai buna securitate a sistemului.

### Functionalitati
1. Verificare executabile, permisiuni;
2. Verificare procese;
3. Verificare versiuni pachete, verificare sume de control.

### Structura Proiectului
* main.sh: Scriptul principal ce executa celelalte scripturi.
* check_executables.sh: Verifica si gestioneaza executabilele.
* check_permissions.sh: Verifica permisiunile fisierelor, cu SUID si GUID setate.
* check_processes.sh: Monitorizeaza procesele active si verifica utilizarea resurselor.
* check_packets.sh: Verifica versiunea pachetelor instalate.
* check_controlsum.sh: Verifica sumele de control pentru verificarea modificarilor neautorizate.

### Utilizare
1. git clone https://github.com/dlandrei03/check-security-linux.git
2. cd check-security-linux
3. sudo bash main.sh

### Detalii Scripturi

##### main.sh
Executa toate scripturile pentru a verifica si remedia probleme de securitate

##### check_executables.sh
* Verifica directoarele binare pentru fisiere neexecutabile;
* Permite stergerea sau modificarea permisiunilor acestora.

##### check_permissions.sh
* Verifica fisierele ce au setate SUID sau SGID;
* Daca others au drept de executie asupra acestuia, apare un warning;
* Ofera posibilitatea de adaugare intr-o baza de date a acelor fisiere considerate safe de utilizator;
* Permite stergerea dreptului de executie pentru aceste fisiere.

##### check_processes.sh
* Verifica procesele consumatoare de CPU/MEM
* Pentru cele care consuma mai mult de 10% din CPU sau MEM, verifica procesele deschise de acestea
* Creeaza o baza date pentru fisierel considerate safe de utilizator
* (To do) Permite inchiderea procesului

##### check_packets.sh
* Verifica versiunea actuala a pachetelor si o compara cu cea aflata pe linux
* Permite actualizarea pachetelor

##### check_controlsum.sh
* Contine o baza de date (o creeaza la lansare daca nu exista) cu sumele de control ale pachetelor de pe linux
* (To do) Permite actualizarea sumei de control in cazul in care pachetul a fost modificat
* Pentru pachetele cu sume de control diferite fata de cele initiale apare un warning

### Documentatie
* https://www.javatpoint.com/linux-file-system
* https://askubuntu.com/questions/221385/how-to-find-which-package-can-be-updated
* https://forums.linuxmint.com/viewtopic.php?t=359105
* https://www.linkedin.com/advice/3/what-implications-setting-suid-sgid-sticky-abvde

# 17.06.2024
### Alegerea Temei
* Script pentru detectia riscurilor de securitate intr-un sistem linux
    * Verificare executabile, permisiuni
    * Verificare procese
    * Verificare versiuni pachete, verificare sume de control

# 18.06.2024
### Documentatie
* Am cautat resurse si materiale necesare pentru dezvoltarea scriptului
    * Verificare fisiere corupte: [linuxmint](https://forums.linuxmint.com/viewtopic.php?t=359105)  
    * Lista pachete vechi ce pot fi updatate: [askubuntu](https://askubuntu.com/questions/221385/how-to-find-which-package-can-be-updated)  
    * Sistemul de partitionare al linux-ului, pentru aflarea executabilelor: [javatpoint](https://www.javatpoint.com/linux-file-system)  
    * Probleme legate de securitate (SGID, SUID) user group permissions pentru executabile: [linkedin](https://www.linkedin.com/advice/3/what-implications-setting-suid-sgid-sticky-abvde)

# 19.06.2024
### Creearea Scripturilor
* Am creeat scripturile check_executables.sh, check_permissions.sh
* M-am documentat cu privire la README.md (sintaxa, cum ar trebui sa arate)
    * O introducere cu elemente [specifice](https://medium.com/@saumya.ranjan/how-to-write-a-readme-md-file-markdown-file-20cb7cbcd6f)  
    * Pentru invatare mai profunda, un [tutorial interactiv](https://www.markdowntutorial.com/)
    * README.md final, cu ce trebuie sa [contina](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/)

# 21.06.2024
### Creearea Scripturilor
* Am creeat scriptul check_processes.sh
    * Verificarea proceselor (parinti) sa fie cei asteptati
    * Atentionarea utilizatorului printr-un warning in cazul in care parintele nu este cel asteptat

# 24.06.2024 - 25.06.2024
### Creearea Scripturilor
* Am modificat scriptul main.sh
    * Adaugarea unui nou director pentru stocarea log-urilor
* Am creeat scripturile check_packets.sh, check_controlsum.sh