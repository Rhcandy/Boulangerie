package servelet;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.entityframework.client.GenericEntity;

import dao.Connector;

@WebServlet( name = "AchatServelet" ,value = "/AchatServelet")
public class AchatServelet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double qtt = Double.parseDouble(request.getParameter("qtt"));
        int IngredientsId = Integer.parseInt(request.getParameter("ingredients"));
        double prix = Double.parseDouble(request.getParameter("prix"));

        try(GenericEntity service=new GenericEntity(Connector.getConnection());){
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate localDate = LocalDate.parse((request.getParameter("date")), formatter);
            Timestamp date = Timestamp.valueOf(localDate.atStartOfDay());
            service.execute("insert into Achats (qtt_initiale,qtt_reste,Prix_Unitaire,date_expiration,Id_Ingredients) values (?,?,?,?,?)",qtt,qtt,prix,date,IngredientsId);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } 
        response.sendRedirect(request.getContextPath()+"/home");
        
    }

}
