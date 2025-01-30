package servelet;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;
import model.Categories;
import model.HistoPrixProduit;

@WebServlet(name = "HistoPrix", value = "/histoPrix")
public class PrixServelet extends HttpServlet {

     public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try( GenericEntity service=new GenericEntity(Connector.getConnection());) {
             List<HistoPrixProduit> Produit_prix =service.findAll(HistoPrixProduit.class);
             List<Categories> categories =service.findAll(Categories.class);
            
             request.setAttribute("Produit_prix", Produit_prix);
             request.setAttribute("categories", categories);


        } catch (Exception e) {
           System.out.println(e.getMessage());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/prix.jsp");
        dispatcher.forward(request, response);
        
    }

}
