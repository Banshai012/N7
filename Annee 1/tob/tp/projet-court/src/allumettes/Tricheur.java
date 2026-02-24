package allumettes;

/**
 * Classe représentant une stratégie de tricheur.
 * Le joueur triche en retirant secrètement des allumettes.
 */
public class Tricheur implements Strategie {

    /** Nom de la stratégie. */
    private String strategie;

    /**
     * Constructeur de la classe Tricheur.
     * Initialise la stratégie avec le nom "Tricheur".
     */
    public Tricheur() {
        this.strategie = "Tricheur";
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
     * Effectue une prise en trichant, en laissant 2 allumettes restantes.
     *
     * @param jeu le jeu en cours.
     * @param nom le nom du joueur.
     * @return le nombre d'allumettes prises (toujours 1).
     * @throws OperationInterditeException si une opération interdite est détectée.
     */
    public int getPriseS(Jeu jeu, String nom) throws OperationInterditeException {
        System.out.println("[Je triche...]");
        int prise = jeu.getNombreAllumettes() - 2;
        for (int i = 0; i < prise; i++) {
            try {
                jeu.retirer(1);
            } catch (CoupInvalideException e) {
            }
        }
        System.out.println("[Allumettes restantes : 2]");
        return 1;
    }
}
