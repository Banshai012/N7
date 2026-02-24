

public class Cellule {

    /** Un element de la liste */
    private double element;
    /** La cellule suivante */
    private Cellule suivante;
    /** La taille de la cellule */
    private int taille;

    public Cellule(double element) {
        this.element = element;
        this.suivante = null;
        this.taille = 1;
    }

    public int taille() {
        return this.taille;
    }

    public boolean contient(double element) {
        if (this != null) {
            if (this.element == element) {
                return true;
            }
            this.suivante.contient(element);
        }
        return false;
    }

    public boolean estVide() {
        return this.taille == 0;
    }

    public void ajouter(double element) {
        if (!this.contient(element)) {
            this.suivante = new Cellule(element);
            this.taille += 1;
        }
    }

    /**
     * Supprimer un élément de la liste.
     * @param element
     */
    public void supprimer(double element) {
        if (this.contient(element)) {
            if (this.element == element) {
                this.element = this.suivante.element;
                this.suivante = this.suivante.suivante;
                this.taille -= 1;
            } else {
                this.suivante.supprimer(element);
            }
            
        }
    }

}
