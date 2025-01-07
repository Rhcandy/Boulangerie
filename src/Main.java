
import java.util.List;

import org.entityframework.client.GenericEntity;

import com.google.gson.Gson;

import dao.Connector;
import model.Produit;

public class Main {
 public static void main(String[] args) {
   
    try (GenericEntity service=new GenericEntity(Connector.getConnection());){
         //Timestamp dtFabrique = new Timestamp(System.currentTimeMillis());
         //service.getNgContext().execute("Insert into Fabrication_ (qtt_initiale, Dt_Fabrique, Id_Produit) VALUES (?, NOW(), ?)",50 ,produits.get(0).getId_Produit());
         /* List<Fabrication> fabs =service.findAll(Fabrication.class); */
          List<Produit> Produits =service.findAll(Produit.class);
        for (Produit fab : Produits) {
          Gson gson=new Gson();
          String json =gson.toJson(fab);
          System.out.println(json);
         }
         service.close();
         
      } 
    catch (Exception e) {
        e.printStackTrace();
    }
 }
}
