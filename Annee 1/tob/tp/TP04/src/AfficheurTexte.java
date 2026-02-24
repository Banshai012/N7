import java.awt.Color;

public class AfficheurTexte {
    
    public static void TextePoint(double x, double y, Color c) {
        System.out.println("Point {");
        System.out.println("    x = " + x);
        System.out.println("    y = " + y);
        System.out.println("    couleur = " + c);
        System.out.println("}");
    }

    public static void TexteLigne(double x1, double y1, double x2, double y2, Color c) {
        System.out.println("Ligne {");
        System.out.println("    x1 = " + x1);
        System.out.println("    y1 = " + y1);
        System.out.println("    x2 = " + x2);
        System.out.println("    y2 = " + y2);
        System.out.println("    couleur = " + c);
        System.out.println("}");
    }

    public static void TexteCercle(double centreX, double centreY, double rayon, Color c) {
        System.out.println("Cercle {");
        System.out.println("    centre_x = " + centreX);
        System.out.println("    centre_y = " + centreY);
        System.out.println("    rayon = " + rayon);
        System.out.print("    couleur = ");
        System.out.println(c);
        System.out.println("}");
    }

    public static void TexteTexte(double x, double y, String texte, Color c) {
        System.out.println("Texte {");
        System.out.println("    x = " + x);
        System.out.println("    y = " + y);
        System.out.println("    texte = " + texte);
        System.out.println("    couleur = " + c);
        System.out.println("}");

    }
}
