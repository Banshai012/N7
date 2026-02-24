package allumettes;

/**
 * Classe représentant une stratégie rapide.
 * Le joueur retire le maximum d'allumettes autorisé.
 */
public class Rapide implements Strategie {

    /** Nom de la stratégie. */
    private String strategie;

    /**
     * Constructeur de la classe Rapide.
     * Initialise la stratégie avec le nom "Rapide".
     */
    public Rapide() {
        this.strategie = "Rapide";
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
     * Détermine le nombre d'allumettes à retirer (maximum autorisé).
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes à retirer.
     */
    public int getPriseS(Jeu jeu, String nom) {
        int nbAll = jeu.getNombreAllumettes();
        return Math.min(jeu.PRISE_MAX, nbAll);
    }
}
