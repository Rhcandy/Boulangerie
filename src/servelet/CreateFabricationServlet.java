package servelet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;

@WebServlet( name = "CreateFabricationServlet" ,value = "/CreateFabricationServlet")
public class CreateFabricationServlet extends HttpServlet {
   
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int qtt = Integer.parseInt(request.getParameter("qtt"));
        int produitId = Integer.parseInt(request.getParameter("produit"));

        try(GenericEntity service=new GenericEntity(Connector.getConnection());){
            service.execute("insert into Fabrication_ (qtt_initiale,Dt_Fabrique,Id_Produit) values (?,NOW(),?)", qtt,produitId);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } 
        response.sendRedirect(request.getContextPath()+"/home");
        
    }
} 
