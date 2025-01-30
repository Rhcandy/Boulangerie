package model;

import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "genre")
public class Genre {
    @Primary(auto = true)
    private int Id_Genre;
    private String Nom;
    
    public int getId_Genre() {
        return Id_Genre;
    }
    public void setId_Genre(int idUnite) {
        this.Id_Genre = idUnite;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        this.Nom = nom;
    }

}
