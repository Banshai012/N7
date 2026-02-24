import java.awt.Color;

/** Un segment est défini pas ses deux points qui constituent ses
 * extrémités.  Un segment peut être affiché et translaté.
 *
 * @author	Xavier Crégut
 * @version	1.9
 */
public class Segment {

	private Point extremite1;
	private Point extremite2;
	private Color couleur;

	/**  Construire un Segment à partir de ses deux points extrémités.
	 *  @param ext1	le premier point extrémité
	 *  @param ext2	le deuxième point extrémité
	 */
	public Segment(Point ext1, Point ext2) {
		this.extremite1 = ext1;
		this.extremite2 = ext2;
		this.couleur = Color.green;
	}

   /** Translater le segment.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
	public void translater(double dx, double dy) {
		this.extremite1.translater(dx, dy);
		this.extremite2.translater(dx, dy);
	}

	/** Obtenir la longueur du segment.
	 * @return la longueur du segment
	 */
	public double longueur() {
		return this.extremite1.distance(this.extremite2);
	}

	/** Afficher le segment.  Le segment est affiché sous la forme :
	 * <PRE>
	 *		[extremite1-extremite2]
	 * </PRE>
	 */
	public void afficher() {
		System.out.print("[");
		this.extremite1.afficher();
		System.out.print("-");
		this.extremite2.afficher();
		System.out.print("]");
	}

	/** Obtenir la couleur du segment.
	 * @return la couleur du segment
	 */
	public Color getCouleur() {
		return this.couleur;
	}

	/** Changer la couleur du segment.
	 * @param nouvelleCouleur nouvelle couleur
	 */
	public void setCouleur(Color nouvelleCouleur) {
		this.couleur = nouvelleCouleur;
	}

	/** Recupérer la position du milieu d'un segment
	 * @return point du segment dont on veut le milieu
	 */
	public Point milieu(){
		Point p1 = new Point((this.extremite1.getX()+this.extremite2.getX())/2, (this.extremite1.getY()+this.extremite2.getY())/2);
		return(p1);
	}

	/** Récupérer le point d'intersection de deux segments
	 * @param s2 segment avec lequel on veut trouver l'intersection
	 * @return point d'intersection des deux segments
	 */
	public Point intersection(Segment s2){
		double x1 = this.extremite1.getX();
		double y1 = this.extremite1.getY();
		double x2 = this.extremite2.getX();
		double y2 = this.extremite2.getY();
		double x3 = s2.extremite1.getX();
		double y3 = s2.extremite1.getY();
		double x4 = s2.extremite2.getX();
		double y4 = s2.extremite2.getY();
		double a1 = (y2-y1)/(x2-x1);
		double b1 = y1 - a1*x1;
		double a2 = (y4-y3)/(x4-x3);
		double b2 = y3 - a2*x3;
		double x = (b2-b1)/(a1-a2);
		double y = (b2-b1)/(a1-a2)*a1+b1;
		Point p = new Point(x, y);
		return(p);
	}
}
