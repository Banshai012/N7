package allumettes;

import java.util.Random;

/**
 * Classe représentant une stratégie naïve.
 * Le joueur retire un nombre aléatoire d'allumettes entre 1 et 3.
 */
public class Naif implements Strategie {

    /** Nom de la stratégie. */
    private String strategie;

    /**
     * Constructeur de la classe Naif.
     * Initialise la stratégie avec le nom "Naif".
     */
    public Naif() {
        this.strategie = "Naif";
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
     * Détermine le nombre d'allumettes à retirer (aléatoire entre 1 et 3).
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes à retirer.
     */
    public int getPriseS(Jeu jeu, String nom) {
        int nbAll = jeu.getNombreAllumettes();
        int max = Math.min(jeu.PRISE_MAX, nbAll);
        Random random = new Random();
        return random.nextInt(max) + 1;
    }
}
