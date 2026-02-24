%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%

cities %names of cities
D      %distance matrix bw cities
pos    %x-y pos of the cities

%%%%%%EXO 1 (modeliser et afficher le graphe) %%%%%

A=(D<500); %A faire; %adj matrix
viz_adj(D,A,pos,cities);
viz_adj(D,graphPower(A, 2),pos,cities);
viz_adj(D,graphPower(A, 3),pos,cities);
viz_adj(D,graphPower(A, 10),pos,cities);
viz_adj(D,graphPower(A, 12),pos,cities);

%Augmenter n à l'infini ne sert à rien, il y a une limite

%%%%%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
viz_adj(D,graphPower(A, 3) - graphPower(A, 2),pos,cities);

%Q2 - nb de chemins de 3 sauts
sum(sum(A^3));

%Q3 - nb de chemins <=3
sum(sum(A^3 + A^2 + A));

%%%%%%%% EXO 3 %%%%%



%On regarde si les couples sont dans le même graphe
c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%%%%%%%% EXO 4%%%%%
isEulerien(A)

%%%%%%%% EXO 5%%%%%
porteeEulerien(D)
