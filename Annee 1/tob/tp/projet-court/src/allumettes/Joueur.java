package allumettes;

/**
 * Classe représentant un joueur dans le jeu des allumettes.
 * Chaque joueur a un nom et une stratégie associée.
 */
public class Joueur {

    /** Nom du joueur. */
    private String nom;

    /** Stratégie du joueur. */
    private Strategie niveau;

    /**
     * Constructeur de la classe Joueur.
     *
     * @param nom le nom du joueur.
     * @param niveau la stratégie associée au joueur.
     */
    public Joueur(String nom, Strategie niveau) {
        this.nom = nom;
        this.niveau = niveau;
    }

    /**
     * Retourne le nom du joueur.
     *
     * @return le nom du joueur.
     */
    public String getNom() {
        return this.nom;
    }

    /**
     * Retourne la stratégie du joueur.
     *
     * @return la stratégie du joueur.
     */
    public Strategie getNiveau() {
        return this.niveau;
    }

    /**
     * Demande au joueur de déterminer le nombre d'allumettes à retirer
     * en fonction de sa stratégie.
     *
     * @param jeu le jeu en cours.
     * @return le nombre d'allumettes à retirer.
     * @throws OperationInterditeException si une opération interdite est détectée.
     */
    public int getPrise(Jeu jeu) throws OperationInterditeException {
        return this.getNiveau().getPriseS(jeu, this.getNom());
    }
}
