package allumettes;

public class Arbitre {

    private Joueur j1;
    private Joueur j2;
    private Joueur enCours;
    private boolean confiant;

    public Arbitre(Joueur j1, Joueur j2) {
        this.j1 = j1;
        this.j2 = j2;
        this.enCours = j1;
    }

    public Arbitre(Joueur j1, Joueur j2, Jeu jeu, boolean confiant) {
        this.j1 = j1;
        this.j2 = j2;
        this.enCours = j1;
        this.confiant = confiant;
    }

    public Joueur getJoueur1() {
        return this.j1;
    }

    public Joueur getJoueur2() {
        return this.j2;
    }

    public Joueur getCoursJoueur() {
        return this.enCours;
    }

    public void setJoueur() {
        if (this.getCoursJoueur() == this.getJoueur1()) {
            this.enCours = this.getJoueur2();
        } else {
            this.enCours = this.getJoueur1();
        }
    }

    public int prise(Jeu jeu) throws CoupInvalideException, OperationInterditeException {

        if (this.confiant) {
            Jeu jeu2 = new Procuration(jeu.getNombreAllumettes());
            return (this.getCoursJoueur().getPrise(jeu2));
        }

        return (this.getCoursJoueur().getPrise(jeu));
    }

    public void arbitrer(Jeu jeu) throws CoupInvalideException,
    OperationInterditeException {
        try {
            while (jeu.getNombreAllumettes() > 0) {
                boolean bool = true;
                while (bool) {
                    try {
                        System.out.println("Allumettes restantes : "
                        + jeu.getNombreAllumettes());
                        int enlever = this.prise(jeu);
                        jeu.retirer(enlever);
                        System.out.println(this.getCoursJoueur().getNom() + " prend "
                        + enlever + " allumette" + (enlever > 1 ? "s" : "") + ".");
                        bool = false;
                        this.setJoueur();
                    } catch (CoupInvalideException e) {
                        System.out.println(this.getCoursJoueur().getNom() + " prend "
                        + e.getCoup() + " allumette" + (e.getCoup() > 1 ? "s" : "") + ".");
                        System.out.println("Impossible ! Nombre invalide : "
                        + e.getCoup() + " " + e.getProbleme());
                    } finally {
                        System.out.println();
                    }
                }
            }
            this.setJoueur();
            System.out.println(this.getCoursJoueur().getNom() + " perd !");
            this.setJoueur();
            System.out.println(this.getCoursJoueur().getNom() + " gagne !");
        } catch (OperationInterditeException e) {
            System.out.println("Abandon de la partie car "
            + this.getCoursJoueur().getNom() + " triche !");
        }
    }
}
