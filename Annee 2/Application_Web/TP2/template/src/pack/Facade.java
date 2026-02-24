package pack;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collection;
import java.util.HashMap;

public class Facade {

    private HashMap<Integer, Personne> personnes;
    private HashMap<Integer, Adresse> adresses;
    private Connection con;
    private int idp = 0;
    private int ida = 0;

    public Facade () throws SQLException, ClassNotFoundException {
        String db_url = "jdbc:hsqldb:hsql://localhost/xdb";
        String db_user = "sa";
        Class.forName("org.hsqldb.jdbcDriver");
        con = DriverManager.getConnection(db_url, db_user, null);
        this.personnes = new HashMap<Integer, Personne>();
        this.adresses = new HashMap<Integer, Adresse>();
    }

    public void ajoutPersonne(String nom, String prenom) throws SQLException {
        personnes.put(idp, new Personne(idp, nom, prenom));
        Statement stmt = con.createStatement();
        stmt.executeQuery("INSERT INTO personne VALUES('"+ idp + "','" + nom + "','" + prenom + "'" +")");
    }

    public void ajoutAdresse(String rue, String ville) {
        adresses.put(ida, new Adresse(ida, rue, ville));
    }

    public Collection<Personne> listePersonnes() {
        return personnes.values();
    }

    public Collection<Adresse> listeAdresses() {
        return adresses.values();
    }

    public void associer(int personneId, int adresseId) {
        Personne p = personnes.get(personneId);
        Adresse a = adresses.get(adresseId);
        p.getAdresses().add(a);
    }

}