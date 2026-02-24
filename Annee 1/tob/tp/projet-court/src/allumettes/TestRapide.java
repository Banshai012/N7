package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

import java.beans.Transient;

public class TestRapide {

    private Jeu jeu1, jeu2, jeu3;

    Joueur cobaye;

    @Before
    public void setup() {
        jeu1 = new JeuReel(13);
        jeu2 = new JeuReel(2);
        jeu3 = new JeuReel(1);
    }

    @Test
    public void testRapide() {
        assertEquals(cobaye.getPrise(jeu1), 3);
        assertEquals(cobaye.getPrise(jeu2), 2);
        assertEquals(cobaye.getPrise(jeu3), 1);
    }
    
}