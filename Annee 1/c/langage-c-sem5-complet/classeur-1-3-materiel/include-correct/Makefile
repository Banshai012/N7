# Nom de l'exécutable
EXEC = programme

# Fichiers sources
SRCS = main.c machin.c truc.c

# Fichiers objets générés à partir des sources
OBJS = $(SRCS:.c=.o)

# Options du compilateur
CFLAGS = -Wall -Wextra -std=c11 -g

# Règle principale pour générer l'exécutable
$(EXEC): $(OBJS)
	clang $(CFLAGS) -o $(EXEC) $(OBJS)

# Règle générique pour compiler les fichiers .c en .o
%.o: %.c
	clang $(CFLAGS) -c $< -o $@

# Nettoyer les fichiers objets et l'exécutable
clean:
	rm -f $(OBJS) $(EXEC)

# Phony targets pour éviter les conflits avec des fichiers portant ces noms
.PHONY: clean