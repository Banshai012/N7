
public class EnsembleChaine implements Ensemble {

    private Cellule ensemble;

    public EnsembleChaine(double element) {
        this.ensemble = new Cellule(element);
    }

    public int cardinal() {
        return this.ensemble.taille();
    }

    public boolean estVide() {
        return this.ensemble.estVide();
    }

    public boolean contient(int x) {
        return this.ensemble.contient(x);
    }

    public void ajouter(int x) {
        this.ensemble.ajouter(x);
    }

    public void supprimer(int x) {
        this.ensemble.supprimer(x);
    }

}
