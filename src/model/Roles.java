package model;

import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Roles")
public class Roles {
    @Primary(auto = true)
    private int Id_Role;
    private String Nom;
    public int getId_Role() {
        return Id_Role;
    }
    public void setId_Role(int id_Role) {
        Id_Role = id_Role;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        Nom = nom;
    }
    
    
}
