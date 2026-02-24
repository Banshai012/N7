package allumettes;

import java.util.Scanner;

public class Humain implements Strategie {

    private String strategie;
    private static final Scanner scanner = new Scanner(System.in);

    public Humain() {
        this.strategie = "Humain";
    }

    public String getStrategie() {
        return this.strategie;
    }

    public int getPriseS(Jeu jeu, String Nom) {
        int prise = 1;
        boolean bool = false;

        while (!bool) {
            System.out.print(Nom + ", combien d'allumettes ? ");
            try {
                String input = scanner.next(); // Utilisation du scanner statique

                if (input.equalsIgnoreCase("triche")) {
                    try {
                        jeu.retirer(prise);
                        System.out.println("[Une allumette en moins, plus que " + jeu.getNombreAllumettes() + ". Chut !]");
                    } catch (CoupInvalideException e) {
                    }
                    continue;
                }

                prise = Integer.parseInt(input);
                bool = true;
            } catch (NumberFormatException e) {
                System.out.println("Vous devez donner un entier.");
            }
        }
        return prise;
    }

}