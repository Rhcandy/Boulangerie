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

@WebServlet( name = "SuggestionServelet" ,value = "/SuggestionServelet")
public class SuggestionServelet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String descri =request.getParameter("descri");
        int produitId = Integer.parseInt(request.getParameter("produit"));

        try(GenericEntity service=new GenericEntity(Connector.getConnection());){
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            LocalDate localDates = LocalDate.parse((request.getParameter("date")), formatter);
            Timestamp datefin = Timestamp.valueOf(localDates.atStartOfDay());
            
            service.execute("insert into Suggestion (Id_Produit,Date_deb,Date_fin,Descri) values (?,NOW(),?,?)",produitId,datefin,descri);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } 
        response.sendRedirect(request.getContextPath()+"/home");
        
    }
    
}
