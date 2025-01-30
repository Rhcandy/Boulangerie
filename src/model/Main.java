package model;

import java.util.List;

import org.entityframework.client.GenericEntity;

import com.google.gson.Gson;

import dao.Connector;

public class Main {
    public static void main(String[] args) {
         try( GenericEntity service=new GenericEntity(Connector.getConnection());) {
            List<HistoPrixProduit> Produit_prix =service.findAll(HistoPrixProduit.class); 
           
            /*  List<Ingredients> Ingredients =service.findAll(Ingredients.class);
             List<Fabrication> Fabrications =service.findWhere(Fabrication.class,"Dt_Expiration > NOW() ");
             List<Categories> categories =service.findAll(Categories.class);
             List<Vente> ventes = service.findAll(Vente.class);
 */
             for (HistoPrixProduit fab : Produit_prix) {
                Gson gson=new Gson();
                String json =gson.toJson(fab);
                System.out.println(json);
             }

        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
    }

}
