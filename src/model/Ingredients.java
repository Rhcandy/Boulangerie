package model;

import org.entityframework.client.GenericEntity;
import org.entityframework.tools.Col;
import org.entityframework.tools.Primary;
import org.entityframework.tools.RowResult;
import org.entityframework.tools.Table;

import dao.Connector;

@Table(name = "Ingredients")
public class Ingredients {
    @Primary(auto = true)
    @Col(name = "Id_Ingredients")
    private int Id_Ingredients;
    private String Nom;
    @Col(name = "Id_Unite", reference = "Id_Unite")
    private Unites Unite;

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
    public Unites getUnite() {
        return Unite;
    }
    public void setUnite(Unites unite) {
        Unite = unite;
    }
    public  int getstock(){
        int result=0;
        try(GenericEntity service=new GenericEntity(Connector.getConnection());) {
          RowResult resul=service.execute("SELECT qtt_reste_totale FROM vue_qtt_reste_stock_Ingredient where Id_Produit ?",this.getIdIngredients());
          if (resul.next()) { 
            result= resul.getInt("qtt_reste_totale"); // Supposons que RowResult a une méthode pour obtenir le ResultSet
          }
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        return result;
    }

}
