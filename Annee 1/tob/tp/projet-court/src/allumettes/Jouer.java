package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	public static final int NBALL = 13;

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) throws CoupInvalideException,
	OperationInterditeException {
		try {

			verifierNombreArguments(args);

			String[] joueur1 = args[args.length - 2].split("@");
			String[] joueur2 = args[args.length - 1].split("@");

			Joueur j1 = new Joueur(joueur1[0], cut(joueur1[1]));
			Joueur j2 = new Joueur(joueur2[0], cut(joueur2[1]));

			Jeu jeu = new JeuReel(NBALL);

			if (args[0].equals("-confiant")) {
				Arbitre arbitre = new Arbitre(j1, j2, jeu, false);
				arbitre.arbitrer(jeu);
			} else {
				Arbitre arbitre = new Arbitre(j1, j2, jeu, true);
				arbitre.arbitrer(jeu);
			}

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		} catch (java.lang.ArrayIndexOutOfBoundsException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

	private static Strategie cut(String joueur) {
		Strategie strat;
		switch (joueur) {
			case "naif":
				strat = new Naif();
				break;
			case "rapide":
				strat = new Rapide();
				break;
			case "expert":
				strat = new Expert();
				break;
			case "humain":
				strat = new Humain();
				break;
			case "tricheur":
				strat = new Tricheur();
				break;
			default:
				throw new ConfigurationException("Stratégie inconnue : "
				+ joueur);
		}
		return strat;
	}

}
