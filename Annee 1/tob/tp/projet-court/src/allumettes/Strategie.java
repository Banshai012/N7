package allumettes;

/**
 * Interface représentant une stratégie pour jouer au jeu des allumettes.
 */
public interface Strategie {

    /**
     * Retourne le nom de la stratégie.
     *
     * @return le nom de la stratégie.
     */
    String getStrategie();

    /**
     * Détermine le nombre d'allumettes à retirer selon la stratégie.
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes à retirer.
     */
    int getPriseS(Jeu jeu, String nom);
}
