package model;

import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Unites")
public class Unites {
    @Primary(auto = true)
    private int Id_Unite;
    private String Nom;
    
    public int getIdUnite() {
        return Id_Unite;
    }
    public void setIdUnite(int idUnite) {
        this.Id_Unite = idUnite;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        this.Nom = nom;
    }

}
