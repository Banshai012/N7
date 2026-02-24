package allumettes;

import java.util.Random;

/**
 * Classe représentant une stratégie experte.
 * Le joueur joue de manière optimale pour maximiser ses chances de gagner.
 */
public class Expert implements Strategie {

    /** Nom de la stratégie. */
    private String strategie;
    private static final int PRISE = 3;

    /**
     * Constructeur de la classe Expert.
     * Initialise la stratégie avec le nom "Expert".
     */
    public Expert() {
        this.strategie = "Expert";
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
     * Détermine le nombre d'allumettes à retirer selon une stratégie optimale.
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes à retirer.
     */
    public int getPriseS(Jeu jeu, String nom) {
        int nbAll = jeu.getNombreAllumettes();
        switch (nbAll % (PRISE + 1)) {
            case 1:
                int max = Math.min(PRISE, nbAll);
                Random random = new Random();
                return random.nextInt(max) + 1;
            case 2:
                return 1;
            case PRISE:
                return 2;
            default:
                return PRISE;
        }
    }
}
