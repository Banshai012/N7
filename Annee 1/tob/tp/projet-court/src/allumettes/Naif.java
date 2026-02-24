package allumettes;
import java.util.Scanner;
import java.util.Random;

public class Naif implements Strategie {

    private String strategie;
    
    public Naif() {
        this.strategie = "Naif";
    }
    
    public String getStrategie() {
        return this.strategie;
    }

    public int getPriseS(Jeu jeu, String Nom) {
        int nbAll = jeu.getNombreAllumettes();
        int max = Math.min(3, nbAll);
        Random random = new Random();
        int prise = random.nextInt(max) + 1; //valeur aléatoire entre 1 et 3
        return prise;
    }

}