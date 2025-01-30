package model;

import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name="Clients")
public class Clients {
    @Primary(auto=true)
    private int Id_Client;
    private String Nom;
    
    public int getId_Client() {
        return Id_Client;
    }
    public void setId_Client(int id_Client) {
        Id_Client = id_Client;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        Nom = nom;
    }

    
    
}

