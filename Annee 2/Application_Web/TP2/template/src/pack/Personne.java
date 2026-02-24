package pack;

import java.util.ArrayList;
import java.util.Collection;

public class Personne {

    private int id;
    private String nom;
    private String prenom;
    private Collection<Adresse> Adresses;

    public Personne (int id, String nom, String prenom) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.Adresses = new ArrayList<Adresse>();
    }

    public int getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public Collection<Adresse> getAdresses() {
        return Adresses;
    }
}