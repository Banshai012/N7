import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;

/**
  * Classe de test (incomplète) de la classe Cercle.
  * @author	Benjamin Krief
  */

public class CercleTest {

	// précision pour les comparaisons réelle
	public final static double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B, C, D, E;

	// Les cercles du sujet
	private Cercle C1, C2, C3;

	@Before public void setUp() {
		// Construire les points
		A = new Point(2, 6);
		B = new Point(4, 10);
		C = new Point(4, 1);
		D = new Point(8, 1);
		E = new Point(8, 4);

		// Construire les cercles
		C1 = new Cercle(C, D);
		C2 = new Cercle(A, B, Color.green);
        C3 = Cercle.creerCercle(D, E);
	}

	/** Vérifier si deux points ont mêmes coordonnées.
	  * @param p1 le premier point
	  * @param p2 le deuxième point
	  */
    static void memesCoordonnees(String message, Point p1, Point p2) {
        assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
		assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
	}

	@Test public void testerE12C1() {
		memesCoordonnees("E12 : Centre de C1 incorrect", new Point((C.getX()+D.getX())/2, (C.getY()+D.getY())/2), C1.getCentre());
		assertEquals("E12 : Rayon de C1 incorrect", C.distance(D)/2, C1.getRayon(), EPSILON);
		assertEquals(Color.blue, C1.getCouleur());
	}

	@Test public void testerE13C2() {
		memesCoordonnees("E13 : Centre de C2 incorrect", new Point((A.getX()+B.getX())/2, (A.getY()+B.getY())/2), C2.getCentre());
		assertEquals("E13 : Rayon de C2 incorrect", A.distance(B)/2, C2.getRayon(), EPSILON);
		assertEquals(Color.green, C2.getCouleur());
	}

	@Test public void testerE14C3() {
		memesCoordonnees("E14 : Centre de C3 incorrect", D, C3.getCentre());
		assertEquals("E14 : Rayon de C3 incorrect", D.distance(E), C3.getRayon(), EPSILON);
		assertEquals(Color.blue, C3.getCouleur());
	}


}
