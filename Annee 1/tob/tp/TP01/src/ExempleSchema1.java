public class ExempleSchema1 {

    public static void main(String[] args) {
        Point p1 = new Point(2 , 3);
        Point p2 = new Point(6 , 9);
        Point p3 = new Point(11 , 4);
        Segment s1 = new Segment(p1, p2);
        Segment s2 = new Segment(p2, p3);
        Point p4 = s1.milieu();
        Point p5 = s2.milieu();
        Segment s4 = new Segment(p4, p3);
        Segment s5 = new Segment(p5, p1);
        Point p7 = s4.intersection(s5);
        p7.afficher();
    }
}