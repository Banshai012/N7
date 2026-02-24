package allumettes;

import java.util.Scanner;

/**
 * Classe représentant une stratégie humaine pour jouer au jeu des allumettes.
 * Le joueur humain saisit le nombre d'allumettes qu'il souhaite retirer.
 */
public class Humain implements Strategie {

    /** Nom de la stratégie. */
    private String strategie;

    /** Scanner pour lire les entrées utilisateur. */
    private static final Scanner SCANNER = new Scanner(System.in);

    /**
     * Constructeur de la classe Humain.
     * Initialise la stratégie avec le nom "Humain".
     */
    public Humain() {
        this.strategie = "Humain";
    }

    /**
     * Retourne le nom de la stratégie.
     *
     * @return le nom de la stratégie.
     */
    public String getStrategie() {
        return this.strategie;
    }

    /**
     * Demande au joueur humain de saisir le nombre d'allumettes à retirer.
     * Si le joueur entre "triche", une allumette est retirée en secret.
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes que le joueur souhaite retirer.
     * @throws OperationInterditeException si une opération interdite est détectée.
     */
    public int getPriseS(Jeu jeu, String nom) throws OperationInterditeException {
        int prise = 1;
        boolean bool = false;

        while (!bool) {
            System.out.print(nom + ", combien d'allumettes ? ");
            try {
                String input = SCANNER.next();

                if (input.equalsIgnoreCase("triche")) {
                    try {
                        jeu.retirer(prise);
                        System.out.println("[Une allumette en moins, plus que "
                        + jeu.getNombreAllumettes() + ". Chut !]");
                    } catch (CoupInvalideException e) {
                    }
                    continue;
                }

                prise = Integer.parseInt(input);
                bool = true;
            } catch (NumberFormatException e) {
                System.out.println("Vous devez donner un entier.");
            }
        }
        return prise;
    }

}
