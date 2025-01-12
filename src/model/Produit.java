package model;

import javax.persistence.Table;

import org.entityframework.client.GenericEntity;
import org.entityframework.tools.Col;
import org.entityframework.tools.FK;
import org.entityframework.tools.Primary;
import org.entityframework.tools.RowResult;

import dao.Connector;

@Table(name = "Produit")
public class Produit {
    @Primary(auto = true)
    private int Id_Produit;
    private String Nom;
    private int Duree_conservation;

    @FK(Recettes.class)
    @Col(name = "Id_Recettes")
    private Recettes Recette; 

    @FK(Categories.class)
    @Col(name = "Id_Categorie")
    private Categories Categorie;

    
   
   
    public int getId_Produit() {
        return Id_Produit;
    }
    public void setId_Produit(int id_Produit) {
        Id_Produit = id_Produit;
    }
    public String getNom() {
        return Nom;
    }
    public void setNom(String nom) {
        Nom = nom;
    }
    public int getDuree_conservation() {
        return Duree_conservation;
    }
    public void setDuree_conservation(int duree_conservation) {
        Duree_conservation = duree_conservation;
    }
     public Recettes getRecette() {
        return Recette;
    }
    public void setRecette(Recettes recette) {
        Recette = recette;
    } 
    public Categories getCategorie() {
        return Categorie;
    }
    public void setCategorie(Categories categorie) {
        Categorie = categorie;
    }
    
    public  double getstock(){
        double result=0;
        try(GenericEntity service=new GenericEntity(Connector.getConnection());) {
          RowResult resul=service.execute("SELECT qtt_reste_totale FROM vue_qtt_reste_totale where Id_Produit = ?",this.getId_Produit());
          if (resul.next()) { 
            return resul.getDouble("qtt_reste_totale");
          } // Supposons que RowResult a une méthode pour obtenir le ResultSet
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        return result;
    }

    public  double getprixvente(){
        double result=0;
        try(GenericEntity service=new GenericEntity(Connector.getConnection());) {
          RowResult resul=service.execute("SELECT prix_vente FROM vue_prix_vente where Id_Produit = ?",this.getId_Produit());
            if (resul.next()) {
                return resul.getDouble("prix_vente"); // Supposons que RowResult a une méthode pour obtenir le ResultSet
            }
        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        return result;
    } 


}
