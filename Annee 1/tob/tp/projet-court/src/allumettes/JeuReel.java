package allumettes;

public class JeuReel implements Jeu {
    private int nbAll;

    public JeuReel(int nbAll) {
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
            throw new CoupInvalideException(nbPrises,
            "(> " + this.getNombreAllumettes() + ")");
        }
        if (nbPrises > PRISE_MAX) {
            throw new CoupInvalideException(nbPrises, "(> " + PRISE_MAX + ")");
        }
        this.nbAll = this.getNombreAllumettes() - nbPrises;
    }
}
