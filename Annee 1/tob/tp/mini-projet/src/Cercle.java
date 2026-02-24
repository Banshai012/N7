import java.awt.Color;

/**
 * Créer un cercle de plusieurs manières possibles, ainsi que de pouvoir le translater,
 * changer ses paramètres et obtenir ses paramètres.
 * @author Benjamin Krief
 */

public class Cercle implements Mesurable2D {

    /** Rayon du cercle. */
    private double rayon;
    /** Centre du cercle. */
    private Point centre;
    /** Couleur du cercle. */
    private Color couleur;
    /** Changer PI en constante de classe. */
    public static final double PI = Math.PI;

    /**
     * Créer un cercle à partir de son centre et de son rayon.
     * @param centre le centre du cercle
     * @param rayon le rayon du cercle
     */
    public Cercle(Point centre, double rayon) {
        assert centre != null : "Le centre ne doit pas être null";
        assert rayon > 0 : "Le rayon doit être strictement positif";
        this.centre = new Point(centre.getX(), centre.getY());
        this.rayon = rayon;
        this.couleur = Color.blue;
    }

    /**
     * Créer un cercle à partir de deux points.
     * @param p1 la première extrémité du diamètre
     * @param p2 la seconde extrémité du diamètre
     */
    public Cercle(Point p1, Point p2) {
        assert p1 != null : "Le premier point ne doit pas être null";
        assert p2 != null : "Le second point ne doit pas être null";
        assert p1.distance(p2) > 0 : "Les deux points ne doivent pas être égaux";
        this.centre = new Point((p1.getX() + p2.getX()) / 2, (p1.getY() + p2.getY()) / 2);
        this.rayon = p1.distance(p2) / 2;
        this.couleur = Color.blue;
    }

    /**
     * Créer un cercle à partir de deux points et d'une couleur.
     * @param p1 la première extrémité du diamètre
     * @param p2 la seconde extrémité du diamètre
     * @param c la couleur du cercle
     */
    public Cercle(Point p1, Point p2, Color c) {
        this(p1, p2);
        assert c != null : "La couleur ne doit pas être null";
        this.couleur = c;
    }

   /**
    * Translater le cercle.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
    public void translater(double dx, double dy) {
        this.centre.translater(dx, dy);
    }

    /**
     * Obtenir le centre du cercle.
     * @return le centre du cercle
     */
    public Point getCentre() {
        return new Point(this.centre.getX(), this.centre.getY());
    }

    /**
     * Obtenir le rayon du cercle.
     * @return le rayon du cercle
     */
    public double getRayon() {
        return this.rayon;
    }

    /**
     * Obtenir le diamètre du cercle.
     * @return le diamètre du cercle
     */
    public double getDiametre() {
        return 2 * this.rayon;
    }

    /**
     * Savoir si un point est à l'intérieur du cercle.
     * @param p le point à tester
     * @return true si le point est à l'intérieur du cercle, false sinon
     */
    public boolean contient(Point p) {
        assert p != null : "Le point ne doit pas être null";
        return this.getCentre().distance(p) <= this.getRayon();
    }

    /**
     * Obtenir le perimetre du cercle.
     * @return le perimetre du cercle
     */
    @Override
    public double perimetre() {
        return 2 * PI * this.rayon;
    }

    /**
     * Obtenir l'aire du cercle.
     * @return l'aire du cercle
     */
    @Override
    public double aire() {
        return PI * Math.pow(this.rayon, 2);
    }

    /**
     * Créer un cercle à partir de deux points.
     * @param p1 le centre du cercle
     * @param p2 un point du cercle
     * @return le cercle créé
     */
    public static Cercle creerCercle(Point p1, Point p2) {
        assert p1 != null : "Le premier point ne doit pas être null";
        assert p2 != null : "Le second point ne doit pas être null";
        return new Cercle(p1, p1.distance(p2));
    }

    /**
     * Afficher le cercle.
     * @return le cercle
     */
    public String toString() {
        return "C" + this.rayon + "@" + this.getCentre().toString();
    }

    /**
     * Changer le rayon du cercle.
     * @param r le nouveau rayon
     */
    public void setRayon(double r) {
        assert r > 0 : "Le rayon doit être strictement positif";
        this.rayon = r;
    }

    /**
     * Changer le diamètre du cercle.
     * @param d le nouveau diamètre
     */
    public void setDiametre(double d) {
        assert d > 0 : "Le diamètre doit être strictement positif";
        this.rayon = d / 2;
    }

// Gestion de la couleur

	/** Obtenir la couleur du point.
	 * @return la couleur du point
	 */
    public Color getCouleur() {
        return this.couleur;
    }

    /**
     * Changer la couleur du cercle.
     * @param c la nouvelle couleur
     */
    public void setCouleur(Color c) {
        assert c != null : "La couleur ne doit pas être null";
        this.couleur = c;
    }

}
