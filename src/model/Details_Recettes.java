package model;


import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Table;

@Table(name = "Details_Recettes")
public class Details_Recettes {
    @Primary(auto = true)
    private int Id_Details_Recettes;
    private double qtt;

    @FK(Recettes.class)
    @Col(name = "Id_Recettes")
    private int Id_Recettes;

    @FK(Ingredients.class)
    @Col(name = "Id_Ingredients")
    private Ingredients Ingredients;

    public int getIdDetailsRecettes() {
        return Id_Details_Recettes;
    }

    public void setIdDetailsRecettes(int idDetailsRecettes) {
        this.Id_Details_Recettes = idDetailsRecettes;
    }

    public double getQtt() {
        return qtt;
    }

    public void setQtt(double qtt) {
        this.qtt = qtt;
    }


    public Ingredients getIngredients() {
        return Ingredients;
    }

    public void setIngredients(Ingredients ingredients) {
        Ingredients = ingredients;
    }
}
