package model;

import java.util.List;

import org.entityframework.tools.OneToMany; 
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Recettes")
public class Recettes {
    @Primary(auto = true)
    private int Id_Recettes;

    private String nom="recette";

    @OneToMany(Details_Recettes.class)
    private List<Details_Recettes> composant;
    

    public List<Details_Recettes> getComposant() {
        return composant;
    }
    public void setComposant(List<Details_Recettes> composant) {
        this.composant = composant;
    }
    public int getIdRecettes() {
        return Id_Recettes;
    }
    public void setIdRecettes(int idRecettes) {
        this.Id_Recettes = idRecettes;
    }
    

}
