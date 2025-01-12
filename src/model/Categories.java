package model;

import org.entityframework.tools.Table;
import org.entityframework.tools.Primary;

@Table(name = "Categories")
public class Categories {
    @Primary(auto = true)
    private int Id_Categorie;
    private String Nom;
    
    public int getIdCategorie() {
        return Id_Categorie;
    }
    public void setIdCategorie(int idCategorie) {
        this.Id_Categorie = idCategorie;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        this.Nom = nom;
    }
}
