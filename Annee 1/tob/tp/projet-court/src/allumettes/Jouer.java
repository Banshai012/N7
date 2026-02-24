package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) throws CoupInvalideException {
		try {
				
			verifierNombreArguments(args);

			String[] joueur1 = args[args.length - 2].split("@");
			String[] joueur2 = args[args.length - 1].split("@");
	
			Strategie strat1;
			Strategie strat2;
	
			switch (joueur1[1]) {
				case "naif":
					strat1 = new Naif();
					break;
				case "rapide":
					strat1 = new Rapide();
					break;
				case "expert":
					strat1 = new Expert();
					break;
				case "humain":
					strat1 = new Humain();
					break;
				case "tricheur":
					strat1 = new Tricheur();
					break;
				default:
					throw new ConfigurationException("Stratégie inconnue : " + joueur1[1]);
			}
	
			switch (joueur2[1]) {
				case "naif":
					strat2 = new Naif();
					break;
				case "rapide":
					strat2 = new Rapide();
					break;
				case "expert":
					strat2 = new Expert();
					break;
				case "humain":
					strat2 = new Humain();
					break;
				case "tricheur":
					strat2 = new Tricheur();
					break;
				default:
					throw new ConfigurationException("Stratégie inconnue : " + joueur2[1]);
			}
	
			Joueur j1 = new Joueur(joueur1[0], strat1);
			Joueur j2 = new Joueur(joueur2[0], strat2);
			
			Jeu Jeu = new JeuAll(13);

			if (args[0].equals("-confiant")) {
				Jeu jeu = new JeuAll(13);
				Arbitre arbitre = new Arbitre(j1, j2, jeu);
				arbitre.arbitrer(jeu);
			} else {
				Jeu jeu = new JeuProc(Jeu);
				Arbitre arbitre = new Arbitre(j1, j2, jeu);
				arbitre.arbitrer(jeu);
			}

		} catch (ConfigurationException e) {
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

}
