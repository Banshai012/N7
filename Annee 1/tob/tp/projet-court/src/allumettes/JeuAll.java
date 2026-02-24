package allumettes;

public class JeuAll implements Jeu {
    private int nbAll;

    public JeuAll(int nbAll) {
        this.nbAll = nbAll;
    }

    @Override
    public int getNombreAllumettes() {
        return this.nbAll;
    }

    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises < 1) {
            throw new CoupInvalideException(nbPrises, "(< 1)");
        }
        if (nbPrises > this.getNombreAllumettes()) {
            throw new CoupInvalideException(nbPrises, "(> " + this.getNombreAllumettes() + ")");
        }
        if (nbPrises > 3) {
            throw new CoupInvalideException(nbPrises, "(> 3)");
        }
        this.nbAll = this.getNombreAllumettes() - nbPrises;
    }
}