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
import model.Fabrication;
import model.Ingredients;
import model.Produit;

@WebServlet("/CreateFabricationServlet")
public class CreateFabricationServlet extends HttpServlet {
     public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("ERTYUIOP DSDTFY ");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/index1.jsp");
        dispatcher.forward(request, response);
        
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ERTYUIOP"+request.getParameter("qtt"));
        System.out.println("dfghjkl"+request.getParameter("produit"));
        /* int qtt = Integer.parseInt(request.getParameter("qtt"));
        
        int produitId = Integer.parseInt(request.getParameter("produit"));

        try(GenericEntity service=new GenericEntity(Connector.getConnection());){
            service.execute("insert into Fabrication_ (qtt_initiale,Dt_Fabrique,Id_Produit) values (?,NOW(),?)", qtt,produitId);
        } catch (Exception e) {
            e.printStackTrace();
        } */
        RequestDispatcher dispatcher = request.getRequestDispatcher("/");
        dispatcher.forward(request, response);
        
    }
}
