package allumettes;

public class Procuration implements Jeu {
    private int nbAll;

    public Procuration(int nbAll) {
        this.nbAll = nbAll;
    }

    @Override
    public int getNombreAllumettes() {
        return this.nbAll;
    }

    @Override
    public void retirer(int nbPrises) throws OperationInterditeException {
        throw new OperationInterditeException();
    }

}
