# N7

Meta-dépôt regroupant l'ensemble de mes travaux à l'**ENSEEIHT / INP Toulouse** (2024–2027, filière Réseau & Informatique → spécialité ASR). Chaque projet significatif est intégré en [submodule Git](https://git-scm.com/book/fr/v2/Utilitaires-Git-Sous-modules) plutôt que copié : ça garde l'historique propre et pointe vers le vrai dépôt (le mien, ou celui d'un camarade quand le projet a été fait en groupe).

Cloner avec les submodules :

```bash
git clone --recurse-submodules https://github.com/Banshai012/N7.git
```

## Année 1 (semestre 5–6)

| Dossier | Contenu |
|---|---|
| `c/langage-c-sem5-complet/` | Exercices et notebooks du cours de langage C |
| `c/projet-c-sem5-etu/` *(submodule — [mon dépôt](https://github.com/Banshai012/projet-c-sem5-etu))* | Projet de C : rendu interactif de la fractale de Mandelbrot en SDL2, multi-threadé (pool de tâches) |
| `pim/tp/` | TP de Programmation Impérative en Ada |
| `Compresseur_Texte_Huffman/` | Projet PIM : compression/décompression de texte par codage de Huffman en Ada |
| `tob/tp/` | TP de Théorie des Objets (Java) |
| `Simples-Adventures/` *(submodule, projet de groupe — dépôt de [hocinemediani](https://github.com/hocinemediani/Simples-Adventures))* | Jeu d'aventure en Java |
| `Arduino/` | TP Arduino (dont la bibliothèque DecaDuino pour l'ultra-large bande) |

## Année 2 (semestre 7–8)

| Dossier | Contenu |
|---|---|
| `Application_Web/` | TP1–TP3 : applications web Java (servlets/JSP) |
| `Architecture_des_Ordinateurs/` | TP FPGA (joystick, compteur 7 segments) |
| `Architecture_des_Systemes_dexploitation/` | TP d'ordonnancement (FIFO, Rate Monotonic, Round Robin) |
| `Programmation_Fonctionnelle/` | TP et BE en OCaml |
| `Ressources_TPGraphe/` | TP d'algorithmique de graphes (+ librairie MATLAB BGL fournie) |
| `Vivado/` | Projets FPGA sous Vivado (compteur, UART) |
| `tps-intergiciel/` | TP intergiciel : sockets, RMI, JMS, web services |
| `OpenMP/` *(submodule — [mon dépôt](https://github.com/Banshai012/OpenMP))* | Cours et TP de calcul parallèle OpenMP (factorisation de Cholesky, réductions) |
| `Controle_Apprentissage/` *(submodule — [mon dépôt](https://github.com/Banshai012/Controle_Apprentissage))* | Contrôle d'un drone par apprentissage par renforcement, comparaison de 3 profondeurs de mémoire |
| `Projet_Systemes/N7OS/` *(submodule — [mon dépôt](https://github.com/Banshai012/N7OS))* | Mini système d'exploitation x86 (boot, IRQ, mémoire, processus) — voir le lien direct plus bas |
| `Compilateur-RAT/`, `rat_KRIEF_MEDIANI/` *(submodule, projet de groupe — dépôt de [hocinemediani](https://github.com/hocinemediani/RAT-Compiler))* | Compilateur du langage RAT vers TAM (OCaml) |
| `Interconnexion/` *(submodule, projet de groupe — dépôt de [hocinemediani](https://github.com/hocinemediani/Interconnexion))* | Interconnexion de réseaux d'entreprise (BGP, DHCP, DNS, VoIP, Docker) |
| `Projet_Architecture/` *(submodule, projet de groupe — dépôt de [ik389](https://github.com/ik389/Projet_Architecture))* | Contrôleur UART sur FPGA (VHDL) |
| `Projet_Telecoms/` *(submodule, projet de groupe — dépôt de [ik389](https://github.com/ik389/Projet_Telecoms))* | Projet réseaux de télécommunications |
| `Projet_Donnee_Reparties/`, `Projet_Intergiciel/Projet_Donnee_Reparties/` *(submodule, projet de groupe — dépôt de [AchilleTheux](https://github.com/AchilleTheux/Projet_Donnee_Reparties))* | Systèmes distribués : agents mobiles en RMI |
| `TimeScrimble/` *(submodule, projet de groupe — dépôt de [hocinemediani](https://github.com/hocinemediani/TimeScrimble))* | Application de planification (Java/Maven) |

## Lien direct — N7OS

Le mini OS développé pour le Projet Systèmes est aussi publié séparément : **https://github.com/Banshai012/N7OS**
