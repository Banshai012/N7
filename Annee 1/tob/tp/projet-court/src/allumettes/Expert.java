package allumettes;
import java.util.Scanner;
import java.util.Random;

public class Expert implements Strategie {

    private String strategie;
    
    public Expert() {
        this.strategie = "Expert";
    }
    
    public String getStrategie() {
        return this.strategie;
    }

    public int getPriseS(Jeu jeu, String Nom) {
        int nbAll = jeu.getNombreAllumettes();
        switch (nbAll % 4){
            case 1 :
                int max = Math.min(3, nbAll);
                Random random = new Random();
                int prise = random.nextInt(max) + 1; //valeur aléatoire entre 1 et 3
                return prise;
            case 2 :
                return 1;
            case 3 :
                return 2;
            default :
                return 3;
        }
    }

}