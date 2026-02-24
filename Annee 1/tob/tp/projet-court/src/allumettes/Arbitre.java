package allumettes;

import javax.xml.stream.events.EndElement;

public class Arbitre {

    private Joueur j1;
    private Joueur j2;
    private Joueur EnCours;
    private int nbAll;

    public Arbitre(Joueur j1, Joueur j2, Jeu jeu) {
        this.j1 = j1;
        this.j2 = j2;
        this.EnCours = j1;
        this.nbAll = jeu.getNombreAllumettes();
    }

    public Joueur getJoueur1() {
        return this.j1;
    }

    public Joueur getJoueur2() {
        return this.j2;
    }

    public Joueur getCoursJoueur() {
        return this.EnCours;
    }

    public void setJoueur() {
        if (this.getCoursJoueur() == this.getJoueur1()) {
            this.EnCours = this.getJoueur2();
        } else {
            this.EnCours = this.getJoueur1();
        }
    }

    public void arbitrer(Jeu jeu) throws CoupInvalideException{
        while (jeu.getNombreAllumettes() > 0) {
            boolean bool = true;
            while (bool) {
                try {
                    System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());
                    int Enlever = this.getCoursJoueur().getPrise(jeu, this.getCoursJoueur().getNom());
                    jeu.retirer(Enlever);
                    System.out.println(this.getCoursJoueur().getNom() + " prend " + Enlever + " allumette" + (Enlever > 1 ? "s" : "") + ".");
                    bool = false;
                    this.setJoueur();
                }
                catch (CoupInvalideException e) {
                    System.out.println(this.getCoursJoueur().getNom() + " prend " + e.getCoup() + " allumette" + (e.getCoup() > 1 ? "s" : "") + ".");
                    System.out.println("Impossible ! Nombre invalide : " + e.getCoup() + " " + e.getProbleme());
                }
                finally {
                    System.out.println();
                }
            }
        }
        this.setJoueur();
        System.out.println(this.getCoursJoueur().getNom() + " perd !");
        this.setJoueur();
        System.out.println(this.getCoursJoueur().getNom() + " gagne !");
    }
}
