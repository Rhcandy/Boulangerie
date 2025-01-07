package model;

import java.util.List;

import org.entityframework.tools.Col;
import org.entityframework.tools.OneToMany; 
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Recettes")
public class Recettes {
    @Primary(auto = true)
    @Col(name = "Id_Recettes")
    private int Id_Recettes;
    @OneToMany(foreignCol = "Id_Recettes",target = Details_Recettes.class)
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
