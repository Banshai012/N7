import java.awt.Color;

import afficheur.AfficheurSVG;
import afficheur.Ecran;

/** Construire le schéma proposé dans le sujet de TP avec des points,
  * et des segments.
  *
  * @author	Xavier Crégut
  * @version	$Revision: 1.7 $
  */
public class ExempleSchema1 {

	/** Construire le schéma et le manipuler.
	  * Le schéma est affiché.
	  * @param args les arguments de la ligne de commande
	  */
	public static void main(String[] args) {

		// Construire un écran
		//Ecran ecran = new Ecran("ExempleEcran", 400, 250, 15);
		//ecran.dessinerAxes();

		// Dessiner avec l'afficheur SVG
		//AfficheurSVG svg = new AfficheurSVG("ExempleSchema1.svg", "Mode SVG",400, 250);

		// Créer les trois segments
		Point p1 = new Point(3, 2);
		Point p2 = new Point(6, 9);
		Point p3 = new Point(11, 4);
		Segment s12 = new Segment(p1, p2);
		//svg.dessinerLigne(p1.getX(), p1.getY(), p2.getX(), p2.getY(), Color.red);
		//s12.dessiner(ecran);
		AfficheurTexte.TextePoint(p1.getX(), p1.getY(), p1.getCouleur());
		Segment s23 = new Segment(p2, p3);
		//svg.dessinerLigne(p2.getX(), p2.getY(), p3.getX(), p3.getY(), Color.red);
		//s23.dessiner(ecran);
		Segment s31 = new Segment(p3, p1);
		//svg.dessinerLigne(p3.getX(), p3.getY(), p1.getX(), p1.getY(), Color.red);
		//s31.dessiner(ecran);

		// Créer le barycentre
		double sx = p1.getX() + p2.getX() + p3.getX();
		double sy = p1.getY() + p2.getY() + p3.getY();
		Point barycentre = new Point(sx / 3, sy / 3);
		//svg.dessinerPoint(barycentre.getX(), barycentre.getY(), Color.blue);
		//barycentre.dessiner(ecran);

		// Afficher le schéma
		System.out.println("Le schéma est composé de : ");
		s12.afficher();		System.out.println();
		s23.afficher();		System.out.println();
		s31.afficher();		System.out.println();
		barycentre.afficher();	System.out.println();
		//svg.ecrire();
		//svg.ecrire("TP04/src/schema.svg");

		// Translater le tout de (4, -3)
		//barycentre.translater(4, -3);
		//s12.translater(4, -3);
		//s23.translater(4, -3);
		//s31.translater(4, -3);
		//s12.dessiner(ecran);
		//s23.dessiner(ecran);
		//s31.dessiner(ecran);
		//barycentre.dessiner(ecran);
		// On obtient que le barycentre n'est pas au bonne endroit car si on déplace un segment, on déplace deux points, donc faire 3 translations, c'est pareil que translater un point 2 fois.

	}

}
