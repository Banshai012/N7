package allumettes;

public class Tricheur implements Strategie {

    private String strategie;
    
    public Tricheur() {
        this.strategie = "Tricheur";
    }
    
    public String getStrategie() {
        return this.strategie;
    }

    public int getPriseS(Jeu jeu, String Nom) {
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