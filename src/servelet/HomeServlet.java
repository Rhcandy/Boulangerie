package servelet;



import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;




import dao.Connector;
import model.Categories;
import model.Fabrication;
import model.Ingredients;
import model.Produit;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "Home", value = "/")
public class HomeServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try( GenericEntity service=new GenericEntity(Connector.getConnection());) {
             List<Produit> Produits =service.findAll(Produit.class);
             List<Ingredients> Ingredients =service.findAll(Ingredients.class);
             List<Fabrication> Fabrications =service.findWhere(Fabrication.class,"Dt_Expiration > NOW() ");
             List<Categories> categories =service.findAll(Categories.class);

             request.setAttribute("Produits", Produits);
             request.setAttribute("Ingredients", Ingredients);
             request.setAttribute("Fabrications", Fabrications);
             request.setAttribute("categories", categories);

        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/index1.jsp");
        dispatcher.forward(request, response);
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
           
           
            
            request.setAttribute("success", "Insertion reussie!");
            
        } catch (Exception e) {
            
            request.setAttribute("error", "Error:" + e.getMessage());
            e.printStackTrace();
        }
       
    }

}

