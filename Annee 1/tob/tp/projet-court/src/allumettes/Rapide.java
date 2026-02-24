package allumettes;
import java.util.Scanner;
import java.util.Random;

public class Rapide implements Strategie {

    private String strategie;
    
    public Rapide() {
        this.strategie = "Rapide";
    }
    
    public String getStrategie() {
        return this.strategie;
    }

    public int getPriseS(Jeu jeu, String Nom) {
        int nbAll = jeu.getNombreAllumettes();
        int prise = Math.min(3, nbAll);
        return prise;
    }

}