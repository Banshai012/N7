package allumettes;

public class Joueur {

    private String nom;
    private Strategie niveau;

    public Joueur(String nom, Strategie niveau) {
        this.nom = nom;
        this.niveau = niveau;
    }

    public String getNom() {
        return this.nom;
    }

    public Strategie getNiveau() {
        return this.niveau;
    }

    public int getPrise(Jeu jeu, String Nom) {
        return this.getNiveau().getPriseS(jeu, Nom);
    }

}
