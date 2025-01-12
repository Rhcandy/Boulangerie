package model;

import org.entityframework.client.GenericEntity;
import org.entityframework.tools.Primary;
import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.RowResult;
import org.entityframework.tools.Table;

import dao.Connector;

@Table(name = "Ingredients")
public class Ingredients {
    @Primary(auto = true)
    private int Id_Ingredients;
    private String Nom;

    @FK(Unites.class)
    @Col(name = "Id_Unite")
    private Unites Unite;
    private boolean Is_Nature ;

    public int getIdIngredients() {
        return Id_Ingredients;
    }
    public void setIdIngredients(int idIngredients) {
        this.Id_Ingredients = idIngredients;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        this.Nom = nom;
    }

    public boolean getIs_Nature(){
        return Is_Nature;
    }

    public void setIs_Nature(boolean nature)
    {
        this.Is_Nature = nature;
    }

    public Unites getUnite() {
        return Unite;
    }
    public void setUnite(Unites unite) {
        Unite = unite;
    }
    public  double getstock(){
        double result=0;
        try(GenericEntity service=new GenericEntity(Connector.getConnection());) {
          RowResult resul=service.execute("SELECT qtt_reste_totale FROM vue_qtt_reste_stock_Ingredient where Id_Ingredients = ?",this.getIdIngredients());
          if (resul.next()) { 
            return resul.getDouble("qtt_reste_totale"); // Supposons que RowResult a une méthode pour obtenir le ResultSet
          }
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        return result;
    }

}
