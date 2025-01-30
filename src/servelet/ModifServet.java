package servelet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;
import model.Produit;

@WebServlet( name = "Modifprod" ,value = "/Modifprod")
public class ModifServet extends HttpServlet  {
      
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double prix = Double.parseDouble(request.getParameter("prix"));
        int produitId = Integer.parseInt(request.getParameter("produitId"));

        try(GenericEntity service=new GenericEntity(Connector.getConnection());){
           Produit newprod= service.findById(produitId, Produit.class);
           newprod.setprixvente(prix);
           
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } 
        response.sendRedirect(request.getContextPath()+"/home");
        
    }
    
}
