package allumettes;

/** Exception qui indique qu'un coup invalide est joué.
 * @author	Xavier Crégut
 * @version	$Revision: 1.3 $
 */
public class OperationInterditeException extends Exception {

	/** Initialiser CoupInvalideException à partir du coup joué
	 * et du problème identifié.  Par exemple, on peut avoir coup
	 * qui vaut 0 et le problème "< 1".
	 */
	public OperationInterditeException() {
		super("Abandon de la partie car Xavier triche !");
	}

}
