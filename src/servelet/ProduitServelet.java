package servelet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;
import model.Categories;
import model.Details_Recettes;

import model.Ingredients;
import model.Produit;
import model.Recettes;

@WebServlet(name = "insertProduit", value = "/insertProduit")
public class ProduitServelet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try (GenericEntity service=new GenericEntity(Connector.getConnection())){ 
             
            Produit prod =new Produit();
            prod.setNom(request.getParameter("nom"));
            prod.setDuree_conservation(Integer.parseInt(request.getParameter("duree")));
            prod.setCategorie(service.findById(Integer.parseInt(request.getParameter("categ")), Categories.class));
            
            // Récupération des données du formulaire
            String[] ingredients = request.getParameterValues("ingredients[]");
            String[] quantites = request.getParameterValues("quantites[]");
            
            // Création de la recette
            Recettes recette = new Recettes();
            
            int id =(int) (service.save(recette));
            
            
            List<Details_Recettes> composants = new ArrayList<>();

            
            for (int i = 0; i < ingredients.length; i++) {
                int idIngredient = Integer.parseInt(ingredients[i]);
                double qtt = Double.parseDouble(quantites[i]);
                // Création des détails de la recette
                Details_Recettes details = new Details_Recettes();
                details.setIngredients(service.findById(idIngredient, Ingredients.class)); // Supposant qu'un constructeur minimal existe
                details.setQtt(qtt);
                details.setId_Recettes(id);
                service.save(details);
                composants.add(details);
            }
            recette.setIdRecettes(id);
            prod.setRecette(recette);
            
            int idprod =(int)(service.save(prod));
            prod.setId_Produit(idprod);
            prod.setprixvente(Double.parseDouble(request.getParameter("prix")));
            response.sendRedirect(request.getContextPath()+"/home"); 

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    
    
}
