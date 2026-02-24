
public class EnsembleOrdonneChaine implements EnsembleOrdonne {


    /** Un element de la liste */
    private int element;
    /** La cellule suivante */
    private EnsembleOrdonneChaine suivante;
    /** La taille de la cellule */
    private int taille;

    public EnsembleOrdonneChaine(int element) {
        this.element = element;
        this.suivante = null;
        this.taille = 1;
    }

    public int cardinal() {
        return this.taille;
    }

    public boolean contient(int element) {
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

    public void ajouter(int element) {
        if (!this.contient(element)) {
            if (element > this.element && element < this.suivante.element){
                EnsembleOrdonneChaine C = new EnsembleOrdonneChaine(element);
                C.suivante = this.suivante;
                this.suivante = C;
                this.taille += 1;
            }
        }
    }

    public void supprimer(int element) {
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

    public int minimum() {
        return this.element;
    }
    
}